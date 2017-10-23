module ZOMG
  module IDL
    module Visitors
      class HashMaker  # "Maker" so as not to confuse w/ class Hash

        def visit_Specification(o)
          accept_by_children(o)
        end

        def visit_Struct(o)
          { o.name =>
            { "node-type" => "struct",
              "definition" => accept_by_children(o).
                map { |kid|
                  (kid.is_a?(Array) && kid.length == 1) ? kid.first : kid
                } } }
        end

        def visit_Member(o)  # can actually be a list of members of same type
          type = unwrap_possible_hash(o.type.accept(self))
          o.children.map { |c|
            { c.accept(self) => { "node-type" => "member", "type" => type } }
          }
        end

        def visit_Enum(o)
          name_to_type_and_defn(o, "enum", { "values" => o.children })
        end

        def visit_Union(o)
          name_to_type_and_defn(o, "union",
                                { "switch_type" => o.switch_type.accept(self),
                                  "contents" => accept_by_children(o) })
        end

        # TODO: CHECK THIS OUT!
        def visit_Case(o)
          res = accept_by_children(o)
          value = res.shift
          type, name = unwrap_possible_array(res) 
          { value => { name => type } }
        end

        def visit_Typedef(o)
          defn = unwrap_possible_hash o.type_spec.accept(self)
          o.name = accept_by_children(o).first  # always only 1
          name_to_type_and_defn(o, "typedef", defn)
        end

        def visit_ArrayDeclarator(o)
          name_to_type_and_kids_acceptance(o, "array")
        end

        # THIS HAS NO UNIQUE NAME, SO SHOULD NEVER BE A HASH ENTRY!
        def visit_Sequence(o)
          what, qty = accept_by_children(o)
          description = { "type" => what }
          description["length"] = qty.to_i if qty  # may be nil
          { "sequence" => description }
        end

        def visit_Constant(o)
          type  = o.type.accept(self)
          value = unwrap_possible_array(o.value.accept(self))
          name_to_type_and_defn(o, "const",
                                { "type" => type, "value" => value })
        end

        def visit_Interface(o)
          header = o.header.accept(self)
          name = header.keys.first
          contents = accept_by_children(o)
          if (ancestor = header.values.first["header-children"]&.first)
            contents << { "ancestor" => ancestor }
          end
          contents = unwrap_possible_array(contents)
          { name => { "node-type" => "interface", "contents" => contents } }
        end

        def visit_Operation(o)
          body = { "contents" => accept_by_children(o) }.
            merge({ "returns" => o.returns.accept(self),
                    "oneway"  => o.attribute })
          if o.raises && o.raises.any?
            body["raises"] = o.raises.map { |c| c.accept(self) }
          end
          body["context"] = o.context.accept(self) if o.context
          { o.name => { "node-type" => "operation", "body" => body } }
        end

        # TODO: CHECK THIS OUT!
        def visit_Parameter(o)
          { o.declarator.accept(self) =>
            { "attribute" => o.attribute.accept(self),
              "type" => o.type.accept(self) } }
        end

        def visit_ScopedName(o)
          o.children.any? ? name_to_type_and_kids_acceptance(o, "scoped-name") : o.name
        end

        def visit_Attribute(o)
          # do these in this order because of
          # the way some of these parsers work
          type = o.type.accept(self)
          # readonly = o.readonly
          name = accept_by_children(o).first
          { name => { "node-type" => "attribute", "type" => type } }
        end

        def visit_Module(o)
          name_to_type_and_kids_acceptance(o, "module")
        end

        def visit_Exception(o)
          name_to_type_and_kids_acceptance(o, "exception")
        end

        def visit_ValueBoxDcl(o)
          name_to_type_and_kids_acceptance(o, "value-box")
        end

        # THIS HAS NO UNIQUE NAME, SO SHOULD NEVER BE A HASH ENTRY!
        def visit_UnaryMinus(o)
          { "unary-minus" =>
            { "node-type" => "unary-minus", "contents" => accept_by_children(o) } }
        end

        %w(Context ElementSpec WString).each do |type|
          define_method(:"visit_#{type}") { |o| accept_by_children(o) }
        end

        %w(ArraySize CaseLabel UnaryPlus).each do |type|
          define_method(:"visit_#{type}") { |o| o.children.accept(self) }
        end

        {
          "AmpersandExpr" => :ampersand,
          "DivideExpr"    => :divide,
          "MinusExpr"     => :minus,
          "ModulusExpr"   => :modulus,
          "MultiplyExpr"  => :multiply,
          "OrExpr"        => :or,
          "PlusExpr"      => :plus,
          "ShiftLeftExpr" => :lshift,
        }.each do |type,sym|
          define_method(:"visit_#{type}") do |o|
            { sym.to_s => { "left" => o.left.accept(self),
                            "right" => o.right.accept(self) } }
          end
        end

        %w(
          BooleanLiteral
          CharacterLiteral
          ForwardDeclaration
          StringLiteral
          WideCharacterLiteral
          WideStringLiteral
        ).each do |type|
          define_method(:"visit_#{type}") { |o| o.children }
        end

        %w(
          Any
          Boolean
          Char
          Double
          Float
          In
          Long
          Object
          Octet
          Out
          Short
          Void
          WChar
        ).
          each do |type|
            define_method(:"visit_#{type}") { |_o| type.downcase }
          end

        %w(
          InOut
          LongLong
          UnsignedLong
          UnsignedLongLong
          UnsignedShort
        ).each do |type|
          define_method(:"visit_#{type}") do |_o|
            type.split("").map.with_index { |c, idx|
              if idx == 0
                c.downcase
              elsif ("A".."Z").include? c
                "_#{c.downcase}"
              else
                c
              end
            }.join.sub(/^unsigned_/, "u")
          end
        end

        def visit_IntegerLiteral(o)
          o.children.to_i
        end

        def visit_FloatingPointLiteral(o)
          o.children.to_f
        end

        def visit_InterfaceHeader(o)
          { o.name =>
            { "node-type" => "interface-header",
              "abstract"  => o.abstract,
              "contents"  => accept_by_children(o) } }
        end

        def visit_DefaultLabel(_o)
          "default"
        end

        def visit_String(o)
          name = "string"
          name << "<#{accept_by_children(o).join(" ")}>" if o.children.any?
          name
        end

        def visit_SimpleDeclarator(o)
          o.name
        end

        def accept(target)
          target.accept(self)
        end

        private

        def accept_by_children(o)
          o.children.map { |c| unwrap_possible_hash(c.accept(self)) }
        end

        def name_to_type_and_kids_acceptance(o, node_type)
          { o.name =>
            { "node-type" => node_type, "contents" => accept_by_children(o) } }
        end

        def name_to_type_and_defn(o, node_type, definition)
          { o.name =>
            { "node-type"  => node_type,
              "definition" => definition } }
        end

        def unwrap_possible_array(a)
          while a.is_a?(Array) && a.count == 1
            a = a.first
          end
          a
        end

        def unwrap_possible_hash(h)
          return h unless h.is_a? Hash
          return h.keys.first if h.keys.count == 1 && h.values == [[]]
          h
        end

      end
    end
  end
end

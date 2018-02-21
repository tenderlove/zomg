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
          type = o.type.accept(self)
          o.children.map { |c|
            { c.accept(self) => { "node-type" => "member", "type" => type } }
          }
        end

        def visit_Enum(o)
          name_to_type_and_defn(o, "enum", { "values" => o.children })
        end

        def visit_Union(o)
          kids = accept_by_children(o)
          defns = {}
          labels = []
          kids.each do |kid|
            case kid
            when String
              labels << kid
            when Hash
              if labels.any?
                old_key = kid.keys.first
                kid[[*labels, old_key]] = kid.values.first
                kid.delete old_key
                labels = []
              end
              defns.merge! kid
            end
          end
          name_to_type_and_defn(o, "union",
                                { "switch_type" => o.switch_type.accept(self),
                                  "definition"  => defns })
        end

        def visit_Case(o)
          value, result = accept_by_children(o)
          { value => result }
        end

        def visit_CaseLabel(o)
          # o.children is really a scoped name, wtf?!
          res = o.children.name
          res
        end

        def visit_ElementSpec(o)
          { "node-type" => "element",
            "type"      => o.children.first.accept(self),
            "name"      => o.children.last.accept(self) }
        end

        def visit_Typedef(o)
          defn = o.type_spec.accept(self)
          kid = accept_by_children(o).first
          if kid.is_a? String
            o.name = kid
          elsif kid.is_a?(Hash) &&
                kid.keys.length == 1 &&
                kid.values.first.is_a?(Hash)
            o.name = kid.keys.first
            defn = kid.values.first.merge({"element-type" => defn})
          end
          name_to_type_and_defn(o, "typedef", defn)
        end

        def visit_ArrayDeclarator(o)
          res = { o.name =>
                  { "type" => "array",
                    "size" => accept_by_children(o).first } }
          res
        end

        # THIS HAS NO UNIQUE NAME, SO SHOULD NEVER BE A MULTI-VALUE HASH ENTRY!
        def visit_Sequence(o)
          what, qty = accept_by_children(o)
          description = { "type" => what }
          # if numeric, make it a number, else keep symbolic const (or nil)
          description["length"] = qty =~ /\A\d+(\.0)?\z/ ? qty.to_i : qty
          { "sequence" => description }
        end

        def visit_Constant(o)
          type  = o.type.accept(self)
          value = o.value.accept(self)
          # for some reason strings get wrapped in an extra level of array,
          # like ["foo"], rather than just "foo"
          value = value.first if value.is_a?(Array) && type == "string"
          name_to_type_and_defn(o, "const",
                                { "type" => type, "value" => value })
        end

        def visit_Interface(o)
          defn = { "node-type"  => "interface",
                   "definition" => accept_by_children(o) }
          header = o.header.accept(self)
          parents = header.values.first["parents"]
          defn ["parents"] = parents if parents
          { header.keys.first => defn }
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

        # THIS HAS NO UNIQUE NAME, SO SHOULD NEVER BE A MULTI-VALUE HASH ENTRY!
        def visit_UnaryMinus(o)
          { "unary-minus" =>
            { "node-type" => "unary-minus",
              "contents"  => o.children.accept(self) } }
        end

        %w(Context WString).each do |type|
          define_method(:"visit_#{type}") { |o| accept_by_children(o) }
        end

        %w(ArraySize UnaryPlus).each do |type|
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
            { sym.to_s => { "node-type" => type,
                            "left" => o.left.accept(self),
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
              "parents"   => accept_by_children(o) } }
        end

        def visit_DefaultLabel(_o)
          "default"
        end

        def visit_String(o)
          if o.children.any?
            { "type" => "string", "length" => accept_by_children(o).join(" ") }
          else
            "string"
          end
        end

        def visit_SimpleDeclarator(o)
          o.name
        end

        def accept(target)
          target.accept(self)
        end

        private

        def accept_by_children(o)
          # use Array because sometimes it isn't already one
          # (I've tried to catch them individually and given up),
          # and Array of an Array is the original Array
          Array(o.children).map { |c|
            if c.is_a? String
              # ZOMG currently doesn't handle valuetypes, and
              # will just substitute the string "valuetype". :-(
              puts "WARNING: IGNORING RAW STRING '#{c}'"
              next
            end
            c.accept(self) }.compact  # the raw strings will become nils
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

      end
    end
  end
end

module ZOMG
  module IDL
    module Visitors
      class HashMaker  # "Maker" so as not to confuse w/ class Hash

        def visit_Specification(o)
          { "spec" => accept_children(o) }
        end

        def visit_Struct(o)
          { "struct-#{o.name}" => accept_children(o).inject(&:merge) }
        end

        def visit_Member(o)  # can actually be a list of members of same type
          type = unwrap_possible_hash(o.type.accept(self))
          o.children.
            map { |c| { c.accept(self) => type } }.
            inject(&:merge).
            map { |name, type| ["member-#{name}", type] }.
            to_h
        end

        def visit_Enum(o)
          { "enum-#{o.name}" => o.children }
        end

        def visit_Union(o)
          type = o.switch_type.accept(self) 
          contents = accept_children(o)
          { "union-#{o.name}" =>
            { "type" => type, "contents" => contents } }
        end

        def visit_Case(o)
          res = accept_children(o)
          value = res.shift
          type, name = unwrap_possible_array(res) 
          { value => { name => type } }
        end

        def visit_Typedef(o)
          defn = unwrap_possible_hash o.type_spec.accept(self)
          name = accept_children(o).first  # always only 1
          { "typedef-#{name}" => defn }
        end

        def visit_ArrayDeclarator(o)
          { "array-#{o.name}" => accept_children(o) }
        end

        def visit_Sequence(o)
          what, qty = accept_children(o)
          description = { "type" => what }
          description["length"] = qty.to_i if qty  # may be nil
          { "sequence" => description }
        end

        def visit_Constant(o)
          type  = o.type.accept(self)
          value = unwrap_possible_array(o.value.accept(self))
          { "const-#{o.name}" =>
            { "type" => type, "value" => value } }
        end

        def visit_Interface(o)
          header = o.header.accept(self)
          name = header.keys.first
          contents = accept_children(o)
          if (ancestor = header.values.first["header-children"]&.first)
            contents << { "ancestor" => ancestor }
          end
          contents = unwrap_possible_array(contents)
          { "interface-#{name}" => contents }
        end

        def visit_Operation(o)
          body = { "contents" => accept_children(o) }.
            merge({ "returns" => o.returns.accept(self),
                    "oneway"  => o.attribute })
          if o.raises && o.raises.any?
            body["raises"] = o.raises.map { |c| c.accept(self) }
          end
          body["context"] = o.context.accept(self) if o.context
          { "operation-#{o.name}" => body }
        end

        def visit_Parameter(o)
          { o.declarator.accept(self) =>
            { "attribute" => o.attribute.accept(self),
              "type" => o.type.accept(self) } }
        end

        def visit_ScopedName(o)
          { "#{o.name}" => accept_children(o) }
        end

        def visit_Attribute(o)
          type = o.type.accept(self).keys.first
          # readonly = o.readonly
          name = accept_children(o).first
          { "attribute-#{name}" => type }
        end

        def visit_Module(o)
          { "module-#{o.name}" => accept_children(o) }
        end

        def visit_Exception(o)
          { "exception-#{o.name}" => accept_children(o) }
        end

        def visit_ValueBoxDcl(o)
          { "valuebox-#{o.name}" => accept_children(o) }
        end

        def visit_UnaryMinus(o)
          { "uminus" => o.children.accept(self) }
        end

        %w(Context ElementSpec WString).each do |type|
          define_method(:"visit_#{type}") { |o| accept_children(o) }
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
            { "abstract" => o.abstract,
              "header-children" => accept_children(o) } }
        end

        def visit_DefaultLabel(_o)
          "default"
        end

        def visit_String(o)
          name = "string"
          name << "<#{accept_children(o).join(" ")}>" if o.children.any?
          name
        end

        def visit_SimpleDeclarator(o)
          o.name
        end

        def accept(target)
          target.accept(self)
        end

        private

        def accept_children(o, opts = {})
          o.children.map { |c| unwrap_possible_hash(c.accept(self)) }
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

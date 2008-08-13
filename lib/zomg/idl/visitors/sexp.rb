module ZOMG
  module IDL
    module Visitors
      class Sexp
        def visit_Specification(o)
          [:spec, o.children.map { |c| c.accept(self) }]
        end

        def visit_Struct(o)
          [:struct, o.name, o.children.map { |c| c.accept(self) }]
        end

        def visit_Member(o)
          [:member, o.type.accept(self), o.children.map { |c| c.accept(self) }]
        end

        def visit_Enum(o)
          [:enum, o.name, o.children]
        end

        def visit_Union(o)
          [:union, o.name, o.switch_type.accept(self), o.children.map { |c| c.accept(self) }]
        end

        def visit_Case(o)
          [:case, o.children.map { |c| c.accept(self) }]
        end

        def visit_CaseLabel(o)
          [:label, o.children.accept(self)]
        end

        def visit_ElementSpec(o)
          [:element_spec, o.children.map { |c| c.accept(self) }]
        end

        def visit_Typedef(o)
          [ :typedef,
            o.type_spec.accept(self),
            o.children.map { |c| c.accept(self) }
          ]
        end

        def visit_ArrayDeclarator(o)
          [:array_decl, o.name, o.children.map { |c| c.accept(self) }]
        end

        def visit_Sequence(o)
          [:sequence, o.children.map { |c| c.accept(self) }]
        end

        def visit_Constant(o)
          [ :const,
            o.type.accept(self),
            o.name,
            o.value.accept(self) ]
        end

        def visit_Interface(o)
          [ :interface,
            o.header.accept(self),
            o.children.map { |c| c.accept(self) }
          ]
        end

        def visit_Operation(o)
          [:op,
            o.attribute && :oneway,
            o.returns.accept(self),
            o.name,
            o.children.map { |c| c.accept(self) },
            o.raises && o.raises.map { |c| c.accept(self) },
            o.context && o.context.accept(self)
          ]
        end

        def visit_Parameter(o)
          [ :param,
            o.attribute.accept(self),
            o.type.accept(self),
            o.declarator.accept(self),
          ]
        end

        def visit_ScopedName(o)
          [ :scoped_name,
            o.name,
            o.children.map { |c| c.accept(self) }
          ]
        end

        def visit_Attribute(o)
          [ :attribute,
            o.readonly && :readonly,
            o.type.accept(self),
            o.children.map { |c| c.accept(self) }
          ]
        end

        def visit_Module(o)
          [:module, o.name, o.children.map { |c| c.accept(self) }]
        end

        def visit_Exception(o)
          [:exception, o.name, o.children.map { |c| c.accept(self) }]
        end

        def visit_Context(o)
          [:context, o.children.map { |c| c.accept(self) }]
        end

        def visit_ValueBoxDcl(o)
          [:valuebox, o.name, o.children.accept(self)]
        end

        def visit_UnaryMinus(o)
          [:uminus, o.children.accept(self)]
        end

        def visit_UnaryPlus(o)
          [:uplus, o.children.accept(self)]
        end

        {
          'MultiplyExpr'  => :multiply,
          'ModulusExpr'   => :modulus,
          'PlusExpr'      => :plus,
          'ShiftLeftExpr' => :lshift,
          'MinusExpr'     => :minus,
          'DivideExpr'    => :divide,
          'AmpersandExpr' => :ampersand,
          'OrExpr'        => :or,
        }.each do |type,sym|
          define_method(:"visit_#{type}") do |o|
            [sym, o.left.accept(self), o.right.accept(self)]
          end
        end

        # Terminal nodes
        def visit_Object(o)
          :object
        end

        def visit_WideStringLiteral(o)
          [:wstring_lit, o.children]
        end

        def visit_WideCharacterLiteral(o)
          [:wstring_lit, o.children]
        end

        def visit_StringLiteral(o)
          [:string_lit, o.children]
        end

        def visit_ForwardDeclaration(o)
          [:forward_decl, o.children]
        end

        def visit_FloatingPointLiteral(o)
          [:float, o.children]
        end

        def visit_BooleanLiteral(o)
          [:boolean, o.children]
        end

        def visit_In(o)
          :in
        end

        def visit_Out(o)
          :out
        end

        def visit_Any(o)
          :any
        end

        def visit_InOut(o)
          :in_out
        end

        def visit_InterfaceHeader(o)
          [:header, o.abstract, o.name, o.children.map { |c| c.accept(self) }]
        end

        def visit_DefaultLabel(o)
          [:default]
        end

        def visit_ArraySize(o)
          [:size, o.children.accept(self)]
        end

        def visit_Char(o)
          :char
        end

        def visit_WChar(o)
          :wchar
        end

        def visit_String(o)
          [:string, o.children.map { |c| c.accept(self)}]
        end

        def visit_WString(o)
          [:wstring, o.children.map { |c| c.accept(self)}]
        end

        def visit_Short(o)
          :short
        end

        def visit_Long(o)
          :long
        end

        def visit_LongLong(o)
          :long_long
        end

        def visit_UnsignedLongLong(o)
          :ulong_long
        end

        def visit_Float(o)
          :float
        end

        def visit_UnsignedShort(o)
          :ushort
        end

        def visit_UnsignedLong(o)
          :ulong
        end

        def visit_Double(o)
          :double
        end

        def visit_Boolean(o)
          :boolean
        end

        def visit_Void(o)
          :void
        end

        def visit_Octet(o)
          :octet
        end

        def visit_SimpleDeclarator(o)
          [:decl, o.name]
        end

        def visit_IntegerLiteral(o)
          [:int, o.to_i]
        end

        def visit_CharacterLiteral(o)
          [:charlit, o.children]
        end

        def accept(target)
          target.accept(self)
        end
      end
    end
  end
end

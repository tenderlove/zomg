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
          [:member, o.type, o.children.map { |c| c.accept(self) }]
        end

        def visit_Enum(o)
          [:enum, o.name, o.children]
        end

        def visit_Union(o)
          [:union, o.name, o.switch_type.accept(self), o.children.map { |c| c.accept(self) }]
        end

        def visit_Case(o)
          [:case, o.label.accept(self), o.spec.accept(self)]
        end

        def visit_CaseLabel(o)
          [:label, o.children.accept(self)]
        end

        def visit_ElementSpec(o)
          [:element_spec, o.children.map { |c| c.accept(self) }]
        end

        # Terminal nodes
        def visit_DefaultLabel(o)
          [:default]
        end

        def visit_Char(o)
          :char
        end

        def visit_String(o)
          :string
        end

        def visit_Short(o)
          :short
        end

        def visit_Long(o)
          :long
        end

        def visit_Float(o)
          :float
        end

        def visit_SimpleDeclarator(o)
          [:decl, o.name]
        end

        def visit_IntegerLiteral(o)
          [:int, o.to_i]
        end

        def accept(target)
          target.accept(self)
        end
      end
    end
  end
end

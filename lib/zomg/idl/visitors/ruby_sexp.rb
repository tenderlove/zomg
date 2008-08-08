module ZOMG
  module IDL
    module Visitors
      class RubySexp
        def visit_Specification(o)
          o.children.map { |c| c.accept(self) }
        end

        def visit_Module(o)
          [ :module,
            o.name.upcase.to_sym,
            [:scope, [:block] + o.children.map { |c| c.accept(self) }]
          ]
        end

        def visit_Constant(o)
          [:cdecl, o.name.upcase.to_sym, o.value.accept(self)]
        end

        def visit_IntegerLiteral(o)
          [:lit, o.to_i]
        end

        def accept(target)
          target.accept(self)
        end
      end
    end
  end
end

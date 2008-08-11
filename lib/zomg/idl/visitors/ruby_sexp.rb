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

        def visit_Enum(o)
          [ :cdecl,
            o.name.to_sym,
            [:hash] + o.children.inject([]) { |m,c| 
              m += [[:lit, c.to_sym], [:lit, c.to_sym]]
            }
          ]
        end

        def visit_IntegerLiteral(o)
          [:lit, o.to_i]
        end

        def visit_Struct(o)
          [ :cdecl,
            o.name.to_sym,
            [ :call, [:const, :Struct],
              :new,
              [:array] + o.children.map { |c|
                c.accept(self)
              }.inject([]) { |memo, obj| memo += obj }
            ]
          ]
        end

        def visit_Union(o)
          [ :cdecl,
            o.name.to_sym,
            [ :call, [:const, :Struct],
              :new,
              [:array] + o.children.map { |c|
                c.accept(self)
              }
            ]
          ]
        end

        def visit_Case(o)
          o.spec.accept(self)
        end

        def visit_ElementSpec(o)
          o.children[1].accept(self)
        end

        def visit_Member(o)
          o.children.map { |c| c.accept(self) }
        end

        def visit_SimpleDeclarator(o)
          [:lit, o.name.to_sym]
        end

        def accept(target)
          target.accept(self)
        end
      end
    end
  end
end

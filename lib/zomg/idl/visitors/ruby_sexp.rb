module ZOMG
  module IDL
    module Visitors
      class RubySexp
        def visit_Specification(o)
          [:block] + o.children.map { |c| c.accept(self) }
        end

        def visit_Module(o)
          [ :module,
            o.name.capitalize.to_sym,
            [:scope, [:block] + o.children.map { |c| c.accept(self) }]
          ]
        end

        def visit_Interface(o)
          header = o.header.accept(self)
          header = header ? [:block, header] : [:block]
          [ :module,
            o.header.name.capitalize.to_sym,
            [:scope,
              header +
                o.children.map { |c| c.accept(self) }
            ]
          ]
        end

        def visit_InterfaceHeader(o)
          if o.children.length > 0
            [:fcall, :include,
              [:array] + o.children.map { |c|
                [:const, c.accept(self).to_s.capitalize.to_sym]
            } ]
          else
            nil
          end
        end

        def visit_Exception(o)
          attributes = o.children.length > 0 ?
            [:scope, [:fcall,
              :attr_accessor,
              [:array] +
                o.children.map { |c|
                  c.accept(self)
                }.flatten.map { |att| [:lit, att] }
            ]] : [:scope]

          [:class, o.name.capitalize.to_sym, [:const, :Exception], attributes]
        end

        def visit_Attribute(o)
          [:fcall,
            o.readonly ? :attr_reader : :attr_accessor,
            [:array] +
              o.children.map { |c| [:lit, c.accept(self)] }
          ]
        end

        def visit_ScopedName(o)
          o.name.to_sym
        end

        def visit_Operation(o)
          [ :defn,
            o.name.to_sym,
            [:scope,
              [:block,
                [:args] + o.children.map { |c| c.accept(self).to_s.downcase.to_sym },
                [:fcall, :raise, [:array,
                  [:call, [:const, :NotImplementedError], :new]]
                ]
              ]
            ]
          ]
        end

        def visit_Parameter(o)
          o.declarator.accept(self)
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
            o.name.capitalize.to_sym,
            [ :call, [:const, :Struct],
              :new,
              [:array] + o.children.map { |c|
                c.accept(self)
              }.flatten.map { |lit| [:lit, lit] }
            ]
          ]
        end

        def visit_Union(o)
          [ :cdecl,
            o.name.to_sym,
            [ :call, [:const, :Struct],
              :new,
              [:array] + o.children.map { |c|
                val = c.accept(self)
                val && [:lit, val]
              }.compact
            ]
          ]
        end

        def visit_CaseLabel(o)
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
          o.name.to_sym
        end

        def visit_ArrayDeclarator(o)
          o.name.to_sym
        end

        def visit_Typedef(o)
        end

        def visit_ForwardDeclaration(o)
        end

        def accept(target)
          target.accept(self)
        end
      end
    end
  end
end

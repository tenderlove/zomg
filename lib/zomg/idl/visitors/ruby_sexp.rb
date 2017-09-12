module ZOMG
  module IDL
    module Visitors
      class RubySexp
        def visit_Specification(o)
          [:block] + o.children.map { |c| c.accept(self) }
        end

        def visit_Module(o)
          [ :module,
            classify(o.name),
            [:block] + o.children.map { |c| c.accept(self) }.compact
          ]
        end

        def visit_Interface(o)
          header = o.header.accept(self)
          header = header ? [:block, header] : [:block]
          o.children.each { |c|
            list = c.accept(self)
            if list
              if list.first.is_a?(Symbol)
                header << list
              else
                header += list
              end
            end
          }
          [ :module,
            classify(o.header.name),
            header
          ]
        end

        def visit_InterfaceHeader(o)
          if o.children.length > 0
            [:call, nil, :include,
              [:array] + o.children.map { |c|
                [:const, classify(c.accept(self))]
            } ]
          else
            nil
          end
        end

        def visit_Exception(o)
          result = [:class, classify(o.name), [:const, :Exception]]
          if o.children.length > 0
            result << [:call, nil,
                        :attr_accessor,
                        [:array] +
                          o.children.map { |c|
                            c.accept(self)
                          }.flatten.map { |att| [:lit, att] }
                      ]
          end
          result
        end

        def visit_Attribute(o)
          attributes = []
          o.children.each { |name|
            name = name.accept(self)

            # Reader
            attributes <<
              [:defn, name,
                [:block, [:args],
                  [:call, nil, :raise, [:array,
                    [:call, [:const, :NotImplementedError], :new]]
                  ]
                ]
              ]
            unless o.readonly
              attributes <<
                [:defn, :"#{name}=",
                  [:block, [:args, :_],
                    [:call, nil, :raise, [:array,
                      [:call, [:const, :NotImplementedError], :new]]
                    ]
                  ]
                ]
            end
          }
          attributes
        end

        def visit_ScopedName(o)
          o.name.to_sym
        end

        def visit_Operation(o)
          [ :defn,
            o.name.to_sym,
            [:block,
              [:args] + o.children.map { |c| paramify(c.accept(self)) },
              [:call, nil, :raise, [:array,
                [:call, [:const, :NotImplementedError], :new]]
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

        def visit_ValueBoxDcl(o)
        end

        def visit_Struct(o)
          [ :cdecl,
            classify(o.name),
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
          o.children.last.accept(self)
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

        private
        def classify(string)
          s = string.to_s
          :"#{s.slice(0,1).upcase}#{s[1..-1]}"
        end

        def paramify(string)
          s = string.to_s
          :"#{s.slice(0,1).downcase}#{s[1..-1]}"
        end
      end
    end
  end
end

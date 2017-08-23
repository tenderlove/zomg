require 'helper'

module ZOMG
  module Conversions
    class InterfaceTest < ZOMG::Test
      def setup
        @tree = ZOMG::IDL.parse(<<-eoidl)
          interface Foo {
            void  a ( );
            short b ( in short a );
            long  c ( in short a, out IntSequence b, inout float c );
          };

          interface Bar: Foo, Baz {
            void  d ( );
          };
        eoidl
      end

      def test_to_ruby_sexp
        sexp = nil
        ruby_sexp =
          [:block,
           [:module, :Foo,
            [:block,
             [:defn, :a,
              [:block,
               [:args],
               [:fcall, :raise,
                [:array,
                 [:call, [:const, :NotImplementedError], :new]
                ]
               ]
              ]
             ],
             [:defn, :b,
              [:block,
               [:args, :a],
               [:fcall, :raise,
                [:array,
                 [:call, [:const, :NotImplementedError], :new]
                ]
               ]
              ]
             ],
             [:defn, :c,
              [:block,
               [:args, :a, :b, :c],
               [:fcall, :raise,
                [:array,
                 [:call, [:const, :NotImplementedError], :new]
                ]
               ]
              ]
             ]
            ]
           ],
           [:module, :Bar,
            [:block,
             [:fcall, :include,
              [:array,
               [:const, :Foo],
               [:const, :Baz]
              ]
             ],
             [:defn, :d,
              [:block,
               [:args],
               [:fcall, :raise,
                [:array,
                 [:call, [:const, :NotImplementedError], :new]
                ]
               ]
              ]
             ]
            ]
           ]
          ]

        assert_nothing_raised {
          sexp = @tree.to_ruby_sexp
        }
        assert_equal(ruby_sexp, sexp)
      end
    end
  end
end

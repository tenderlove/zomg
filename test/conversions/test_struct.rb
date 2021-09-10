require 'helper'

module ZOMG
  module Conversions
    class StructTest < ZOMG::Test
      def setup
        @tree = ZOMG::IDL.parse(<<-eoidl)
          struct Foo {
            short   a;
            long    b;
          };
        eoidl
      end
    
      def test_to_ruby_sexp
        sexp = nil
        ruby_sexp = [:block,
                      [:cdecl, :Foo,
                        [:call, [:const, :Struct], :new,
                          [:lit, :a], [:lit, :b]]
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

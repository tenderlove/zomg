require 'helper'

module ZOMG
  module Conversions
    class ExceptionTest < ZOMG::Test
      def setup
        @tree = ZOMG::IDL.parse(<<-eoidl)
          exception not_implemented {};
          exception AvocadoExcpt{
            ::Avocado ex1;
          };
        eoidl
      end

      def test_to_ruby_sexp
        sexp = nil
        assert_nothing_raised {
          sexp = @tree.to_ruby_sexp
        }
        assert_equal([:block,
                      [:class, :Not_implemented,
                       [:const, :Exception]
                      ],
                      [:class, :AvocadoExcpt,
                       [:const, :Exception],
                       [:call, nil, :attr_accessor, [:array, [:lit, :ex1]]]
                      ]
                     ],
                     sexp)
      end
    end
  end
end

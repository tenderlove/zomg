require 'helper'

module ZOMG
  module Conversions
    class AttributeTest < ZOMG::Test
      def setup
        @tree = ZOMG::IDL.parse(<<-eoidl)
          interface Foo {
            attribute long awesome;
          };
        eoidl
      end

      def test_to_ruby_sexp
        sexp = nil
        assert_nothing_raised {
          sexp = @tree.to_ruby_sexp
        }
        assert sexp
        ruby_sexp =
          [:block,
           [:module,
            :Foo,
            [:block,
             [:defn,
              :awesome,
              [:block,
               [:args],
               [:call, nil,
                :raise,
                [:call, [:const, :NotImplementedError], :new]]]],
             [:defn,
              :awesome=,
              [:block,
               [:args, :_],
               [:call, nil,
                :raise,
                [:call, [:const, :NotImplementedError], :new]]]]]]]
        assert_equal(ruby_sexp, sexp)
      end
    end
  end
end

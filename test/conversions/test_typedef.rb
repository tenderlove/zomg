require 'helper'

module ZOMG
  module Conversions
    class TypedefTest < ZOMG::Test
      def setup
        @tree = ZOMG::IDL.parse(<<-eoidl)
          typedef long IntSequence[10];
        eoidl
      end

      def test_to_ruby_sexp
        sexp = nil
        ruby_sexp = [:block, nil]
        assert_nothing_raised {
          sexp = @tree.to_ruby_sexp
        }
        assert_equal(ruby_sexp, sexp)
      end
    end
  end
end

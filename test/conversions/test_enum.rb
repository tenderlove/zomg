require 'helper'

module ZOMG
  module Conversions
    class EnumTest < ZOMG::Test
      def setup
        @tree = ZOMG::IDL.parse(<<-eoidl)
          enum Foo {
            a,
            b
          };
        eoidl
      end

      def test_to_ruby_sexp
        sexp = nil
        ruby_sexp = [[:cdecl, :Foo, [:hash, [:lit, :a], [:lit, :a], [:lit, :b], [:lit, :b]]]]
        assert_nothing_raised {
          sexp = @tree.to_ruby_sexp
        }
        assert_equal(ruby_sexp, sexp)
      end
    end
  end
end

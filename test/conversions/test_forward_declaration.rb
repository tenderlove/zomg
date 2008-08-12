require 'helper'

module ZOMG
  module Conversions
    class ForwardDeclarationTest < ZOMG::Test
      def setup
        @tree = ZOMG::IDL.parse(<<-eoidl)
          interface A;
        eoidl
      end

      # We don't bother with forward declarations in Ruby
      def test_to_ruby_sexp
        sexp = nil
        assert_nothing_raised {
          sexp = @tree.to_ruby_sexp
        }
        assert_equal([:block, nil], sexp)
      end
    end
  end
end

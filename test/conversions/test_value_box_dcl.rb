require 'helper'

module ZOMG
  module Conversions
    class ValueBoxDclTest < ZOMG::Test
      def setup
        @tree = ZOMG::IDL.parse(<<-eoidl)
          valuetype DOMString sequence<unsigned short>;
        eoidl
      end

      # We don't bother with value boxes.  Yay typeless!
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

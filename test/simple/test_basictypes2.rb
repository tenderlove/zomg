require 'helper'

class BasicTypes2Test < ZOMG::Test
  def setup
    @tree = ZOMG::IDL::Parser.parse_file(simple('basictypes2.idl'))
  end

  def test_to_sexp
      @tree.to_sexp.flatten.each do |member|
        assert(
          [ ::String,
            ::Symbol,
            Numeric ].any? { |m| member.is_a?(m) } ||
            [true, false, nil].any? { |m| member == m }
              )
      end
  end
end

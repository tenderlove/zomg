require 'helper'

class BasicTypes3Test < ZOMG::Test
  def setup
    @tree = ZOMG::IDL::Parser.parse_file(simple('basictypes3.idl'))
  end

  def test_readonly
    assert_sexp(
                [:attribute, :readonly, :long, [[:decl, "l2"]]],
                @tree.children[1].children.first
               )
  end

  def test_header
    i2 = @tree.children[1]
    assert_sexp([:header, false, "ex2", [[:scoped_name, "ex1", []]]],
                i2.header
               )
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

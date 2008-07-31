require 'helper'

class BasicTypes4Test < ZOMG::Test
  def setup
    @tree = ZOMG::IDL::Parser.parse_file(simple('basictypes4.idl'))
  end

  def test_module_to_sexp
    assert_sexp(
                [:typedef, [:string, [:int, 10]], [[:decl, "BndString"]]],
                @tree.duhr.Module[0].Interface[0].Typedef[0]
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

require 'helper'

class BasicTypes5Test < ZOMG::Test
  def setup
    @tree = ZOMG::IDL::Parser.parse_file(simple('basictypes5.idl'))
  end

  def test_exception
    assert_sexp([:exception, "not_implemented", []],
                @tree.duhr.Exception[0]
               )
  end

  def test_to_sexp
    assert_nothing_raised { @tree.to_sexp }
  end
end

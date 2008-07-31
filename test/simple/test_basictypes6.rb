require 'helper'

class BasicTypes6Test < ZOMG::Test
  def setup
    @tree = ZOMG::IDL::Parser.parse_file(simple('basictypes6.idl'))
  end

  def test_case
    assert_sexp([:label, [:charlit, "'L'"]],
                @tree.duhr.Interface[0].Union[0].Case[0].CaseLabel[0]
               )
  end

  def test_to_sexp
    assert_nothing_raised {
      @tree.to_sexp
    }
  end
end

require 'helper'

class Array1Test < ZOMG::Test
  def setup
    @tree = ZOMG::IDL::Parser.parse_file(array('array1.idl'))
  end
  
  def test_forward_declaration
    assert_sexp([:forward_decl, 'foo'], @tree.duhr.ForwardDeclaration[0])
  end

  def test_to_sexp
    assert_nothing_raised {
      @tree.to_sexp
    }
  end
end

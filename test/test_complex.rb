require 'helper'

class ComplexTest < ZOMG::Test
  COMPLEX = File.join(ASSETS, 'complex')

  def test_constant_sexp
    tree = ZOMG::IDL::Parser.parse_file(complex('complex4.idl'))
    assert_sexp([:const, [:scoped_name, "longT", []], "long_c", [:int, 1]],
                tree.duhr.Constant[0])
  end

  def test_context_sexp
    tree = ZOMG::IDL::Parser.parse_file(complex('TestIntfContext.idl'))
    operation = tree.duhr.Module[0].Interface[0].Operation[0].tree
    assert_sexp([:context, [[:string_lit, ["\"A*\""]], [:string_lit, ["\"C*\""]], [:string_lit, ["\"X\""]], [:string_lit, ["\"Z\""]]]], operation.context)
  end
end

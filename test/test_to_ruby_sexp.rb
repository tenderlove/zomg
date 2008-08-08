require 'helper'

class RubySexpText < ZOMG::Test
  def setup
    @parser = ZOMG::IDL::Parser.new
  end

  def test_module
    tree = @parser.parse(<<-eoidl)
      module dom
      {
        const unsigned short INDEX_SIZE_ERR = 1;
      };
    eoidl
    assert_equal(
            [[:module, :DOM, [:scope, [:block, [:cdecl, :INDEX_SIZE_ERR, [:lit, 1]]]]]],
            tree.to_ruby_sexp
    )
  end
end

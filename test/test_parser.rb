require 'helper'

class ParserTest < ZOMG::Test
  def setup
    @parser = ZOMG::IDL::Parser.new
  end

  def test_valuetype
    tree = @parser.parse(<<-eoidl)
      module dom
      {
        valuetype DOMString sequence<unsigned short>;
      };
    eoidl
    assert_nothing_raised { tree.to_sexp }
  end
end

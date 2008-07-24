require 'helper'

class ParserTest < ZOMG::Test
  def setup
    @parser = ZOMG::IDL::Parser.new
  end

  def test_initialize
    assert_nothing_raised {
      ZOMG::IDL::Parser.new
    }
  end

  def test_parse_simple
    @parser.parse_file(simple('simple1.idl'))
  end
end

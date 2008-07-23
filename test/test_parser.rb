require 'test/unit'
require 'zomg'

class ParserTest < Test::Unit::TestCase
  def setup
    @parser = ZOMG::IDL::Parser.new
  end

  def test_initialize
    assert_nothing_raised {
      ZOMG::IDL::Parser.new
    }
  end
end

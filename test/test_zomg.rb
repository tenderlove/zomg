require 'test/unit'
require 'zomg'

class ZOMGTest < Test::Unit::TestCase
  def test_oct_literal
    assert_match(ZOMG::IDL::Parser::Oct_Literal, '0123')
  end
end

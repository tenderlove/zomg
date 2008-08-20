require 'helper'

class NodeTest < ZOMG::Test
  def setup
    @tree = ZOMG::IDL::Parser.parse_file(array('array1.idl'))
  end

  def test_to_ruby
    assert_nothing_raised {
      @tree.to_ruby
    }
    ruby_with_prefix = @tree.to_ruby('A::B')
    assert_match(/module A/, ruby_with_prefix)
    assert_match(/module B/, ruby_with_prefix)
  end
end

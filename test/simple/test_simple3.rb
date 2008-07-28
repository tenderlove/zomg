require 'helper'

class Simple3Test < ZOMG::Test
  def setup
    @tree = ZOMG::IDL::Parser.parse_file(simple('simple3.idl'))
  end

  def test_parse_tree
    assert_equal(1, @tree.children.length)
    idl_module = @tree.children.first
    assert_equal(1, idl_module.children.length)

    interface = idl_module.children.first
    assert_equal(1, interface.children.length)
    attribute = interface.children.first
    assert_instance_of(Attribute, attribute)
    assert_equal(1, attribute.children.length)
    assert_equal('test', attribute.children.first.name)
  end
end

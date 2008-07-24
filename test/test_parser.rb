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
    tree = @parser.parse_file(simple('simple1.idl'))
    assert_instance_of(Specification, tree)
    assert_equal(1, tree.children.length)

    idl_module = tree.children.first
    assert_instance_of(Module, idl_module)
    assert_equal('OneWaySimpleTest', idl_module.name)

    assert_equal(1, idl_module.children.length)
    idl_interface = idl_module.children.first
    assert_instance_of(Interface, idl_interface)
    assert_equal('sim1wcor', idl_interface.name)
  end
end

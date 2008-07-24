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

    assert_equal(1, idl_interface.children.length)
    idl_op_decl = idl_interface.children.first
    assert_equal('OneWayMethod', idl_op_decl.name)
    assert_equal('void', idl_op_decl.returns)
    assert_equal('oneway', idl_op_decl.attribute)

    assert_equal(2, idl_op_decl.children.length)

    idl_op_decl.children.each do |child|
      assert_instance_of(Parameter, child)
      assert_equal('in', child.attribute)
    end

    in_str  = idl_op_decl.children.first
    in_long = idl_op_decl.children[1]

    assert_equal('inStr', in_str.name)
    assert_equal('inLong', in_long.name)
  end
end

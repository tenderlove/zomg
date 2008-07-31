require 'helper'

class Simple1Test < ZOMG::Test
  def setup
    @tree = ZOMG::IDL::Parser.parse_file(simple('simple1.idl'))
  end

  def test_parse_simple1
    assert_instance_of(Specification, @tree)
    assert_equal(1, @tree.children.length)

    idl_module = @tree.children.first
    assert_instance_of(Module, idl_module)
    assert_equal('OneWaySimpleTest', idl_module.name)

    assert_equal(1, idl_module.children.length)
    idl_interface = idl_module.children.first
    assert_instance_of(Interface, idl_interface)
    assert_equal('sim1wcor', idl_interface.header.name)

    assert_equal(1, idl_interface.children.length)
    idl_op_decl = idl_interface.children.first
    assert_equal('OneWayMethod', idl_op_decl.name)
    assert_equal(:void, idl_op_decl.returns.to_sexp)
    assert_equal('oneway', idl_op_decl.attribute)

    assert_equal(2, idl_op_decl.children.length)

    idl_op_decl.children.each do |child|
      assert_instance_of(Parameter, child)
      assert_equal(:in, child.attribute.to_sexp)
    end

    in_str  = idl_op_decl.children.first
    in_long = idl_op_decl.children[1]

    assert_equal('inStr', in_str.name)
    assert_equal('inLong', in_long.name)
  end
end

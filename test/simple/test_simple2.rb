require 'helper'

class Simple2Test < ZOMG::Test
  def setup
    @tree = ZOMG::IDL::Parser.parse_file(simple('simple2.idl'))
  end

  def test_parse_simple2
    assert_instance_of(Specification, @tree)
    assert_equal(1, @tree.children.length)

    idl_module = @tree.children.first
    assert_instance_of(Module, idl_module)
    assert_equal('TwoWaySimpleTest', idl_module.name)

    assert_equal(2, idl_module.children.length)
    exception = idl_module.children[0]
    assert_instance_of(Exception, exception)
    assert_equal('SimpleEx', exception.name)

    idl_interface = idl_module.children[1]
    assert_instance_of(Interface, idl_interface)
    assert_equal('sim2wcor', idl_interface.header.name)

    assert_equal(1, idl_interface.children.length)
    idl_op_decl = idl_interface.children.first
    assert_equal('TwoWayMethod', idl_op_decl.name)
    assert_instance_of(String, idl_op_decl.returns)
    assert_nil(idl_op_decl.attribute)
    assert_equal(1, idl_op_decl.raises.length)
    assert_equal('SimpleEx', idl_op_decl.raises.first.name)

    assert_equal(3, idl_op_decl.children.length)
    idl_op_decl.children.each do |child|
      assert_instance_of(Parameter, child)
    end
    assert_equal([:in, :in_out, :out], idl_op_decl.children.map { |x|
      x.attribute.to_sexp
    })
    assert_equal( [String, Long, UnsignedShort],
      idl_op_decl.children.map { |x|
        x.type.class
    })
    assert_equal(%w{ inStr inoutLong outUShort }, idl_op_decl.children.map { |x|
      x.name
    })
  end
end

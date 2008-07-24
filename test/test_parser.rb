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

  def test_parse_simple2
    tree = @parser.parse_file(simple('simple2.idl'))
    assert_instance_of(Specification, tree)
    assert_equal(1, tree.children.length)

    idl_module = tree.children.first
    assert_instance_of(Module, idl_module)
    assert_equal('TwoWaySimpleTest', idl_module.name)

    assert_equal(2, idl_module.children.length)
    exception = idl_module.children[0]
    assert_instance_of(Exception, exception)
    assert_equal('SimpleEx', exception.name)

    idl_interface = idl_module.children[1]
    assert_instance_of(Interface, idl_interface)
    assert_equal('sim2wcor', idl_interface.name)

    assert_equal(1, idl_interface.children.length)
    idl_op_decl = idl_interface.children.first
    assert_equal('TwoWayMethod', idl_op_decl.name)
    assert_equal('string', idl_op_decl.returns)
    assert_nil(idl_op_decl.attribute)
    assert_equal(1, idl_op_decl.raises.length)
    assert_equal('SimpleEx', idl_op_decl.raises.first)

    assert_equal(3, idl_op_decl.children.length)
    idl_op_decl.children.each do |child|
      assert_instance_of(Parameter, child)
    end
    assert_equal(%w{ in inout out }, idl_op_decl.children.map { |x|
      x.attribute
    })
    assert_equal( ['string', 'long', 'unsigned short'],
      idl_op_decl.children.map { |x|
        x.type
    })
    assert_equal(%w{ inStr inoutLong outUShort }, idl_op_decl.children.map { |x|
      x.name
    })
  end

  def test_parse_simple1
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

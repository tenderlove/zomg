require 'helper'

class BasitTypes1Test < ZOMG::Test
  def setup
    @tree = ZOMG::IDL::Parser.parse_file(simple('basictypes1.idl'))
  end

  def test_enum
    assert_equal(6, @tree.children.length)
    (_, enum, _, _, _, _) = *(@tree.children)
    assert enum
    assert_instance_of(Enum, enum)
    assert_equal('Color', enum.name)
    assert_equal(4, enum.children.length)
    assert_equal(%w{ blue green red black }.sort, enum.children.sort)
  end

  def test_struct
    assert_equal(6, @tree.children.length)
    (struct, _, _, _, _, _) = *(@tree.children)
    assert struct
    assert_instance_of(Struct, struct)
    assert_equal('BasicTypes', struct.name)
    assert_instance_of(Array, struct.children)
    assert_equal(10, struct.children.length)
    [
      Short,
      UnsignedShort,
      Long,
      UnsignedLong,
      Float,
      Double,
      Char,
      String,
      Boolean,
      Octet
    ].each_with_index do |type, i|
      assert_instance_of(Member, struct.children[i])
      assert_instance_of(type, struct.children[i].type)
    end
  end
end

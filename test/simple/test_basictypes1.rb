require 'helper'

class BasitTypes1Test < ZOMG::Test
  def setup
    @tree = ZOMG::IDL::Parser.parse_file(simple('basictypes1.idl'))
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

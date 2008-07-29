require 'helper'

class BasitTypes1Test < ZOMG::Test
  def setup
    @tree = ZOMG::IDL::Parser.parse_file(simple('basictypes1.idl'))
  end

  #def test_typedef_long
  #  assert_equal(6, @tree.children.length)
  #  (_, _, _, long, _, _) = *(@tree.children)
  #  assert long
  #end

  def test_union
    assert_equal(6, @tree.children.length)
    (_, _, union, _, _, _) = *(@tree.children)
    assert union
    assert_instance_of(Union, union)
    assert_equal('U', union.name)
    assert_instance_of(Long, union.switch_type)
    assert_instance_of(Array, union.children)
    assert_equal(5, union.children.length)
    union.children.each { |child| assert_instance_of(Case, child) }
    [ CaseLabel,
      CaseLabel,
      CaseLabel,
      CaseLabel,
      DefaultLabel ].each_with_index { |l,i|
        assert_instance_of(l, union.children[i].label)
    }
    assert_equal([10, 20, 50, 60], union.children.find_all { |child|
      child.label.is_a?(CaseLabel)
    }.map { |cl| cl.label.to_i })
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

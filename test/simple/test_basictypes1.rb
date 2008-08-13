require 'helper'

class BasicTypes1Test < ZOMG::Test
  def setup
    @tree = ZOMG::IDL::Parser.parse_file(simple('basictypes1.idl'))
  end

  def test_interface
    assert_equal(6, @tree.children.length)
    (_, _, _, _, _, interface) = *(@tree.children)
    interface.children.each do |child|
      assert_instance_of(Operation, child)
      assert_nothing_raised {
        child.to_sexp
      }
    end
  end

  def test_typedef_long
    assert_equal(6, @tree.children.length)
    (_, _, _, long, seq, _) = *(@tree.children)
    assert long
    assert seq

    assert_instance_of(Typedef, long)
    assert_instance_of(Typedef, seq)
    assert_sexp([:typedef, :long, [[:array_decl, "IntSequence", [[:size, [:int, 10]]]]]], long)
    assert_sexp([:typedef, [:sequence, [:long]], [[:decl, "longSeq"]]], seq)
  end

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
        assert_instance_of(l, union.children[i].children[0])
    }
    assert_equal([10, 20, 50, 60], union.children.find_all { |child|
      child.children[0].is_a?(CaseLabel)
    }.map { |cl| cl.children[0].to_i })
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

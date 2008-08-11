require 'helper'

class UnionTest < ZOMG::Test
  def setup
    @tree = ZOMG::IDL.parse(<<-eoidl)
      union Foo switch(long) {
        case 10: string a;
        case 20: short  b;
        default: char   c;
      };
    eoidl
  end

  def test_to_ruby_sexp
    sexp = nil
    ruby_sexp = [[:cdecl, :Foo, [:call, [:const, :Struct], :new, [:array, [:lit, :a], [:lit, :b], [:lit, :c]]]]]
    assert_nothing_raised {
      sexp = @tree.to_ruby_sexp
    }
    assert_equal(ruby_sexp, sexp)
  end
end

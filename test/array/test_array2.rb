require 'helper'

class ArraysTest < ZOMG::Test
  def setup
  end

  def test_to_sexp
    ['array2.idl', 'array3.idl', 'array4.idl'].each do |file|
      assert_nothing_raised {
        tree = ZOMG::IDL::Parser.parse_file(array(file)).to_sexp
      }
    end
  end
end

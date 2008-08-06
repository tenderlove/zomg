require 'helper'

class ArraysTest < ZOMG::Test
  ['array2.idl', 'array3.idl', 'array4.idl', 'array5.idl'].each do |file|
    define_method(:"test_#{file.gsub('.', '_')}_to_sexp") do
      assert_nothing_raised {
        tree = ZOMG::IDL::Parser.parse_file(array(file)).to_sexp
      }
    end
  end
end

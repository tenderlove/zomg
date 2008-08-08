require 'helper'

class TypecodeTest < ZOMG::Test
  TYPECODE = File.join(ASSETS, 'typecode')
  Dir[File.join(TYPECODE, '*.idl')].each do |file|
    name = File.basename(file)
    define_method(:"test_#{name.gsub('.', '_')}_to_sexp") do
      assert_nothing_raised {
        ZOMG::IDL::Parser.parse_file(file).to_sexp
      }
    end
  end
end

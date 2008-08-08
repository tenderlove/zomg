require 'helper'

class StringTest < ZOMG::Test
  STRING = File.join(ASSETS, 'string')
  Dir[File.join(STRING, '*.idl')].each do |file|
    name = File.basename(file)
    define_method(:"test_#{name.gsub('.', '_')}_to_sexp") do
      assert_nothing_raised {
        ZOMG::IDL::Parser.parse_file(file).to_sexp
      }
    end
  end
end

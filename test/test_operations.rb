require 'helper'

class OperationsTest < ZOMG::Test
  OPERATIONS = File.join(ASSETS, 'operations')
  Dir[File.join(OPERATIONS, '*.idl')].each do |file|
    name = File.basename(file)
    define_method(:"test_#{name.gsub('.', '_')}_to_sexp") do
      assert_nothing_raised {
        ZOMG::IDL::Parser.parse_file(file).to_sexp
      }
    end
  end
end

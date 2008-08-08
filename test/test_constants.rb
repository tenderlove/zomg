require 'helper'

class ConstantTest < ZOMG::Test
  CONSTANTS = File.join(ASSETS, 'constant')

  Dir[File.join(CONSTANTS, '*.idl')].each do |file|
    name = File.basename(file)
    define_method(:"test_#{name.gsub('.', '_')}_to_sexp") do
      assert_nothing_raised {
        ZOMG::IDL::Parser.parse_file(file).to_sexp
      }
    end
  end
end

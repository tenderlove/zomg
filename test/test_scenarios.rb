require 'helper'

class ScenariosTest < ZOMG::Test
  SCENARIOS = File.join(ASSETS, 'scenarios')
  Dir[File.join(SCENARIOS, '*.idl')].each do |file|
    name = File.basename(file)
    define_method(:"test_#{name.gsub('.', '_')}_to_sexp") do
      assert_nothing_raised {
        ZOMG::IDL::Parser.parse_file(file).to_sexp
      }
    end
  end
end

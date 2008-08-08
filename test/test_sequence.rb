require 'helper'

class SequenceTest < ZOMG::Test
  SEQUENCE = File.join(ASSETS, 'sequence')
  Dir[File.join(SEQUENCE, '*.idl')].each do |file|
    name = File.basename(file)
    define_method(:"test_#{name.gsub('.', '_')}_to_sexp") do
      assert_nothing_raised {
        ZOMG::IDL::Parser.parse_file(file).to_sexp
      }
    end
  end
end

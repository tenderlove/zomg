require 'helper'

class ExceptionTest < ZOMG::Test
  EXCEPTION = File.join(ASSETS, 'enum')
  Dir[File.join(EXCEPTION, '*.idl')].each do |file|
    define_method(:"test_#{file.gsub('.', '_')}_to_sexp") do
      assert_nothing_raised {
        ZOMG::IDL::Parser.parse_file(file).to_sexp
      }
    end
  end
end

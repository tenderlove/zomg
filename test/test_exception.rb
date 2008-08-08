require 'helper'

class ExceptionTest < ZOMG::Test
  EXCEPTION = File.join(ASSETS, 'exception')
  Dir[File.join(EXCEPTION, '*.idl')].each do |file|
    name = File.basename(file)
    define_method(:"test_#{name.gsub('.', '_')}_to_sexp") do
      assert_nothing_raised {
        ZOMG::IDL::Parser.parse_file(file).to_sexp
      }
    end
  end
end

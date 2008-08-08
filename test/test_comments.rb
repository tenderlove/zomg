require 'helper'

class CommentsTest < ZOMG::Test
  COMMENTS = File.join(ASSETS, 'comment')
  Dir[File.join(COMMENTS, '*.idl')].each do |file|
    define_method(:"test_#{file.gsub('.', '_')}_to_sexp") do
      assert_nothing_raised {
        ZOMG::IDL::Parser.parse_file(file).to_sexp
      }
    end
  end
end

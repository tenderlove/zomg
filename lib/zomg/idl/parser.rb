module ZOMG
  module IDL
    class Parser < Lexer
      class << self
        def parse_file(filename)
          new.parse_file(filename)
        end
      end
      def initialize
        @scanner = Scanner.new
        @yydebug = false
      end

      def parse_file(filename)
        contents = File.read(filename)
        if contents =~ /^\s*#/
          dir = File.dirname(File.expand_path(filename))
          contents = IO.popen("gcc -E -I #{dir} -I . -", 'w+') { |io|
            io.write(contents)
            io.close_write
            io.read
          }
        end
        @scanner.scan_evaluate(contents)
        do_parse
      end

      def next_token
        token = @scanner.next_token
        return [false, false] unless token
        token = next_token() if token[0] == :T_COMMENT
        token = next_token() if token[0] == :T_PREPROCESSOR
        token = next_token() if token[0] == :T_PRAGMA
        token
      end

      def on_error(error_token_id, error_value, value_stack)
        puts token_to_str(error_token_id)
        puts error_value
        p value_stack
      end
    end
  end
end

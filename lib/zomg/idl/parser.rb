module ZOMG
  module IDL
    class Parser < Lexer
      def initialize
        @scanner = Scanner.new
      end

      def parse_file(filename)
        @scanner.load_file(filename)
        do_parse
      end

      def next_token
        token = @scanner.next_token
        return [false, false] unless token
        token = next_token() if token[0] == :T_COMMENT
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

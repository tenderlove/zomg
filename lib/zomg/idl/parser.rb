module ZOMG
  module IDL
    class Parser < Lexer
      def initialize
        @scanner = Scanner.new
      end
    end
  end
end

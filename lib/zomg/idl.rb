require 'zomg/idl/visitable'
require 'zomg/idl/visitors/sexp'
require 'zomg/idl/visitors/ruby_sexp'
require 'zomg/idl/visitors/duhr'

module ZOMG
  module IDL
    class << self
      def parse(contents)
        ZOMG::IDL::Parser.parse(contents)
      end
    end
  end
end

module ZOMG
  module IDL
    module Nodes
      class Node
        attr_accessor :children
        def initialize(children)
          @children = children
        end
      end
      %w{ Boolean Char Double Float Long Octet Short String UnsignedLong
        UnsignedShort
      }.each { |type| const_set(type.to_sym, Class.new(Node)) }
    end
  end
end

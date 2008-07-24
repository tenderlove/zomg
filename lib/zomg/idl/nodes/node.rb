module ZOMG
  module IDL
    module Nodes
      class Node
        attr_accessor :children
        def initialize(children)
          @children = children
        end
      end
    end
  end
end

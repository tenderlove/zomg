module ZOMG
  module IDL
    module Nodes
      class Specification < Node
        alias :definitions :children
      end
    end
  end
end

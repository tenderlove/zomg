module ZOMG
  module IDL
    module Nodes
      class SimpleDeclarator < Node
        attr_accessor :name
        def initialize(name)
          @name = name
        end
      end
    end
  end
end

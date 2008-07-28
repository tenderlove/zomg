module ZOMG
  module IDL
    module Nodes
      class Struct < Node
        attr_accessor :name
        def initialize(name, children)
          @name = name
          super(children)
        end
      end
    end
  end
end

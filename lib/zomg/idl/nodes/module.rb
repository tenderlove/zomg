module ZOMG
  module IDL
    module Nodes
      class Module < Node
        attr_accessor :name
        alias :definitions :children
        def initialize(name, children)
          super(children)
          @name = name
        end
      end
    end
  end
end

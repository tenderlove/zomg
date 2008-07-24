module ZOMG
  module IDL
    module Nodes
      class Interface < Node
        attr_accessor :name, :abstract
        alias :definitions :children
        def initialize(name, children = [], abstract = false)
          super(children)
          @name = name
          @abstract = abstract
        end
      end
    end
  end
end

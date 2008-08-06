module ZOMG
  module IDL
    module Nodes
      class Constant < Node
        attr_accessor :type, :name
        alias :value :children
        def initialize(type, name, value)
          @type = type
          @name = name
          super(value)
        end
      end
    end
  end
end

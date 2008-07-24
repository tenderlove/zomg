module ZOMG
  module IDL
    module Nodes
      class Attribute < Node
        alias :names :children
        attr_accessor :type
        def initialize(type, names, readonly = false)
          super(names)
          @type = type
        end
      end
    end
  end
end

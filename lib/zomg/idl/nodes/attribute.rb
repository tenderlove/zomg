module ZOMG
  module IDL
    module Nodes
      class Attribute < Node
        alias :names :children
        attr_accessor :type, :readonly
        def initialize(type, names, readonly = false)
          super(names)
          @type = type
          @readonly = readonly
        end
      end
    end
  end
end

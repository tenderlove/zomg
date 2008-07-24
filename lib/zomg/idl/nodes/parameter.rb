module ZOMG
  module IDL
    module Nodes
      class Parameter < Node
        attr_accessor :attribute, :type, :name
        def initialize(attribute, type, name)
          @attribute  = attribute
          @type       = type
          @name       = name
        end
      end
    end
  end
end

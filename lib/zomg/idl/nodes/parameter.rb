module ZOMG
  module IDL
    module Nodes
      class Parameter < Node
        attr_accessor :attribute, :type, :declarator
        def initialize(attribute, type, declarator)
          @attribute  = attribute
          @type       = type
          @declarator = declarator
        end

        def name
          declarator.name
        end
      end
    end
  end
end

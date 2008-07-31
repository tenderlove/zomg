module ZOMG
  module IDL
    module Nodes
      class InterfaceHeader < Node
        attr_accessor :abstract, :name
        def initialize(abstract, name)
          @abstract = abstract
          @name = name
        end
      end
    end
  end
end

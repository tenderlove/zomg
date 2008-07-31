module ZOMG
  module IDL
    module Nodes
      class InterfaceHeader < Node
        attr_accessor :abstract, :name
        def initialize(abstract, name, inheritance_spec = [])
          @abstract = abstract
          @name = name
          super(inheritance_spec)
        end
      end
    end
  end
end

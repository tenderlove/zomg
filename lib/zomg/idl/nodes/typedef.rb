module ZOMG
  module IDL
    module Nodes
      class Typedef < Node
        attr_accessor :type_spec
        def initialize(type_spec, declarators)
          @type_spec = type_spec
          super(declarators)
        end
      end
    end
  end
end

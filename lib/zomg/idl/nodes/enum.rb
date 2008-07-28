module ZOMG
  module IDL
    module Nodes
      class Enum < Node
        attr_accessor :name
        def initialize(name, enumerators)
          super(enumerators)
          @name = name
        end
      end
    end
  end
end

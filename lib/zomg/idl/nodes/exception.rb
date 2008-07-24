module ZOMG
  module IDL
    module Nodes
      class Exception < Node
        attr_accessor :name
        def initialize(name, members)
          super(members)
          @name = name
        end
      end
    end
  end
end

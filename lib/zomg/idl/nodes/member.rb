module ZOMG
  module IDL
    module Nodes
      class Member < Node
        attr_accessor :type
        alias :declarators :children
        def initialize(type, declarators)
          @type = type
          super(declarators)
        end
      end
    end
  end
end

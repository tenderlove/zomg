module ZOMG
  module IDL
    module Nodes
      class Interface < Node
        attr_accessor :header
        def initialize(header, body)
          super(body)
          @header = header
        end
      end
    end
  end
end

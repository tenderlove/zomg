module ZOMG
  module IDL
    module Nodes
      class Union < Node
        attr_accessor :name, :switch_type
        def initialize(name, switch_type, switch_body)
          @name = name
          @switch_type = switch_type
          super(switch_body)
        end
      end
    end
  end
end

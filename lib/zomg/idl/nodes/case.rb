module ZOMG
  module IDL
    module Nodes
      class Case < Node
        def initialize(label, spec)
          super([label, spec])
        end
        def label; children[0]; end
        def spec; children[1]; end
      end
    end
  end
end

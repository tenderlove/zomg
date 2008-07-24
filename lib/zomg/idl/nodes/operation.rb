module ZOMG
  module IDL
    module Nodes
      class Operation < Node
        attr_accessor :attribute, :returns, :name, :raises, :context
        def initialize(attribute, returns, name, params, raises, context)
          super(params)
          @attribute = attribute
          @returns = returns
          @name = name
          @raises = raises
          @context = context
        end
      end
    end
  end
end

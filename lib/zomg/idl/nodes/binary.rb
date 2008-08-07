module ZOMG
  module IDL
    module Nodes
      class Binary < Node
        attr_accessor :left
        alias :right :children
        def initialize(left, right)
          @left = left
          super(right)
        end
      end
      %w{ MultiplyExpr PlusExpr ModulusExpr ShiftLeftExpr MinusExpr
        DivideExpr OrExpr AmpersandExpr
      }.each do |type|
        const_set(type.to_sym, Class.new(Binary))
      end
    end
  end
end

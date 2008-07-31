module ZOMG
  module IDL
    module Visitors
      # Stupid path navigation
      class Duhr
        attr_accessor :tree
        def initialize(tree)
          @tree = tree
        end

        def to_sexp; @tree.to_sexp; end

        def [](i)
          Duhr.new(@tree[i])
        end

        def method_missing(sym, *args)
          klass = ZOMG::IDL::Nodes.const_get(sym)
          Duhr.new(tree.children.find_all { |child| child.is_a?(klass) })
        end
      end
    end
  end
end

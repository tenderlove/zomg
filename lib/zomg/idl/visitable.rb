module ZOMG
  module IDL
    module Visitable
      # Based off the visitor pattern from RubyGarden
      def accept(visitor, &block)
        klass = self.class
        method_name = :"visit_#{klass.name.split(/::/).last}"
        unless visitor.respond_to?(method_name)
          raise "No visitor for #{self.class}"
        end
        visitor.send(method_name, self, &block)
      end
    end
  end
end

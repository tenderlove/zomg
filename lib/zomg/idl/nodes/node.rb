module ZOMG
  module IDL
    module Nodes
      class Node
        include Visitable
        include Visitors

        attr_accessor :children, :name
        def initialize(children = [], options = {})
          @children = children
          options.each { |k,v| send(:"#{k}=", v) }
        end

        def to_i
          children.to_i
        end

        def duhr
          Duhr.new(self)
        end

        def to_hash
          HashMaker.new.accept(self)
        end

        def to_sexp
          # note that this is ZOMG::IDL::Visitors::Sexp,
          # not ::Sexp as from sexp_processor!
          Sexp.new.accept(self)
        end

        def to_ruby_sexp
          RubySexp.new.accept(self)
        end

        def to_ruby(prefix = nil)
          r2r = Ruby2Ruby.new
          ruby_code = r2r.process(::Sexp.from_array(to_ruby_sexp))
          if prefix
            modules = prefix.split(/::/).map { |m| "module #{m}\n" }
            ends = modules.map { |m| "end" }.join("\n")
            "#{modules}#{ruby_code}\n#{ends}"
          else
            ruby_code
          end
        end

      end
      %w{ Boolean Char Double Float Long Octet Short UnsignedLong
        UnsignedShort ElementSpec CaseLabel DefaultLabel IntegerLiteral
        Sequence ArraySize Void In Out InOut CharacterLiteral
        UnsignedLongLong LongLong Any ForwardDeclaration WChar
        FloatingPointLiteral BooleanLiteral Context StringLiteral
        WideStringLiteral WideCharacterLiteral UnaryMinus Object
        UnaryPlus WString String Case Enum Exception ValueBoxDcl
        Struct ScopedName Module ArrayDeclarator SimpleDeclarator
        Specification
      }.each { |type| const_set(type.to_sym, Class.new(Node)) }

      # TODO: there's probably a better way to do this, like messing
      # with the parsing definitions so foo::bar::baz comes out as
      # one scoped name, but i don't grok that well enough yet.  -dja
      def ScopedName.new(*args)
        children, opts = args
        children.first.name += "::#{opts[:name]}" if children.count == 1
        super
      end
    end
  end
end

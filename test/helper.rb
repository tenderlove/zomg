require 'rubygems'
require 'test/unit'
require 'zomg'

module ZOMG
  class Test < Test::Unit::TestCase
    include ZOMG::IDL::Nodes
    ASSETS = File.expand_path(File.join(File.dirname(__FILE__), 'assets'))

    undef :default_test

    def assert_sexp(sexp, obj)
      assert_equal(sexp, obj.to_sexp)
    end

    def method_missing(name, *args)
      super unless args[0]
      file = File.join(ASSETS, name.to_s, args[0])
      super unless File.exist?(file)
      file
    end
  end
end

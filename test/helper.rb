require 'test/unit'
require 'zomg'

module ZOMG
  class Test < Test::Unit::TestCase
    include ZOMG::IDL::Nodes
    ASSETS = File.expand_path(File.join(File.dirname(__FILE__), 'assets'))

    undef :default_test

    def method_missing(name, *args)
      file = File.join(ASSETS, name.to_s, args[0])
      super unless File.exists?(file)
      file
    end
  end
end

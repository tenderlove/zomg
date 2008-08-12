require 'helper'

module ZOMG
  module AssetTests
  end
end

Dir[File.join(ZOMG::Test::ASSETS, '*')].each do |dir|
  next unless File.directory?(dir)
  klass = Class.new(ZOMG::Test) {
    Dir[File.join(dir, '*.idl')].each do |file|
      name = File.basename(file)
      define_method(:setup) do
        @tree = ZOMG::IDL::Parser.parse_file(file)
      end

      define_method(:"test_#{name.gsub('.', '_')}_to_sexp") do
        assert_nothing_raised {
          @tree.to_sexp
        }
      end

      define_method(:"test_#{name.gsub('.', '_')}_to_ruby") do
        ruby = nil
        assert_nothing_raised { ruby = @tree.to_ruby }
        x = Module.new
        assert_nothing_raised { x.module_eval(ruby) }
      end
    end
  }
  test_name = File.basename(dir)
  ZOMG::AssetTests.const_set(:"#{test_name.capitalize}Test", klass)
end

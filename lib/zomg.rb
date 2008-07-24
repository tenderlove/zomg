%w{
  node
  specification
  module
  interface
  operation
  parameter
  exception
}.each { |node_type|
  require "zomg/idl/nodes/#{node_type}"
}
require 'zomg/idl/scanner'
require 'zomg/idl/lexer'
require 'zomg/idl/parser'

module ZOMG
  VERSION = '1.0.0'
end

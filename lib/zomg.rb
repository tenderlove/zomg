require 'ruby2ruby'
require 'zomg/version'
require 'zomg/idl'

%w{
  node
  specification
  interface
  operation
  parameter
  attribute
  member
  union
  typedef
  interface_header
  constant
  binary
}.each { |node_type|
  require "zomg/idl/nodes/#{node_type}"
}
require 'zomg/idl/scanner'
require 'zomg/idl/lexer'
require 'zomg/idl/parser'

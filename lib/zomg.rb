require 'ruby2ruby'
require 'zomg/version'
require 'zomg/idl'

%w{
  node
  attribute
  binary
  constant
  interface
  interface_header
  member
  operation
  parameter
  typedef
  union
}.each { |node_type|
  require "zomg/idl/nodes/#{node_type}"
}
require 'zomg/idl/scanner'
require 'zomg/idl/lexer'
require 'zomg/idl/parser'

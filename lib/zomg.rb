require 'ruby2ruby'
require 'zomg/version'
require 'zomg/idl'

%w{
  node
  specification
  module
  interface
  operation
  parameter
  attribute
  struct
  simple_declarator
  member
  union
  array_declarator
  typedef
  interface_header
  scoped_name
  constant
  binary
}.each { |node_type|
  require "zomg/idl/nodes/#{node_type}"
}
require 'zomg/idl/scanner'
require 'zomg/idl/lexer'
require 'zomg/idl/parser'

require 'zomg/version'
require 'zomg/idl/visitable'
require 'zomg/idl/visitors/sexp'
require 'zomg/idl/visitors/duhr'

%w{
  node
  specification
  module
  interface
  operation
  parameter
  exception
  attribute
  struct
  simple_declarator
  member
  enum
  union
  case
  array_declarator
  typedef
  interface_header
  scoped_name
  string
  constant
  binary
  value_box_dcl
}.each { |node_type|
  require "zomg/idl/nodes/#{node_type}"
}
require 'zomg/idl/scanner'
require 'zomg/idl/lexer'
require 'zomg/idl/parser'

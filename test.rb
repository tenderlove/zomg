require 'rubygems'
require 'ruby2ruby'
require 'zomg'

tree = ZOMG::IDL::Parser.parse(<<-eoidl)
  module dom
  {
    const unsigned short INDEX_SIZE_ERR = 1;
  };
eoidl

puts tree.to_ruby

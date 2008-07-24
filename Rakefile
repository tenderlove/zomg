# -*- ruby -*-

require 'rubygems'
require 'hoe'

GENERATED_SCANNER = 'lib/zomg/idl/scanner.rb'
GENERATED_LEXER = 'lib/zomg/idl/lexer.rb'

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
#require 'zomg'

Hoe.new('zomg', '1.0.0') do |p|
   p.developer('Aaron Patterson', 'aaronp@rubyforge.org')
   p.clean_globs = [GENERATED_LEXER, GENERATED_SCANNER]
end

file GENERATED_LEXER => 'lib/yacc.y' do |t|
  sh "racc -g -o #{t.name} #{t.prerequisites.first}"
end

file GENERATED_SCANNER => 'lib/scanner.rex' do |t|
  sh "frex --independent -o #{t.name} #{t.prerequisites.first}"
end

task :parser => [GENERATED_SCANNER, GENERATED_LEXER]

Rake::Task[:test].prerequisites << :parser
Rake::Task[:check_manifest].prerequisites << :parser

# vim: syntax=Ruby

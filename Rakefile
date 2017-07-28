# -*- ruby -*-

require 'rubygems'
require 'hoe'

GENERATED_SCANNER = 'lib/zomg/idl/scanner.rb'
GENERATED_LEXER = 'lib/zomg/idl/lexer.rb'

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
$DEBUG = ENV['DEBUG']
require 'zomg/version'

HOE = Hoe.spec('zomg') do |p|
   p.developer('Aaron Patterson', 'aaronp@rubyforge.org')
   p.clean_globs = [GENERATED_LEXER, GENERATED_SCANNER]
   p.description = p.paragraphs_of('README.txt', 3..10).join("\n\n")
   p.extra_deps = [['ruby2ruby', '~> 2.0']]
end

file GENERATED_LEXER => 'lib/yacc.y' do |t|
  #sh "racc #{$DEBUG ? '-g' : ''} -o #{t.name} #{t.prerequisites.first}"
  sh "racc -g -o #{t.name} #{t.prerequisites.first}"
end

file GENERATED_SCANNER => 'lib/scanner.rex' do |t|
  sh "frex --independent -o #{t.name} #{t.prerequisites.first}"
end

task :parser => [GENERATED_SCANNER, GENERATED_LEXER]

Rake::Task[:test].prerequisites << :parser
Rake::Task[:check_manifest].prerequisites << :parser

namespace :gem do
  task :spec do
    File.open("#{HOE.name}.gemspec", 'w') do |f|
      HOE.spec.version = "#{HOE.version}.#{Time.now.strftime("%Y%m%d%H%M%S")}"
      f.write(HOE.spec.to_ruby)
    end
  end
end

# vim: syntax=Ruby

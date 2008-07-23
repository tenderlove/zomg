# -*- ruby -*-

require 'rubygems'
require 'hoe'

GENERATED_SCANNER = 'lib/zomg/idl/scanner.rb'

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
#require 'zomg'

Hoe.new('zomg', '1.0.0') do |p|
   p.developer('Aaron Patterson', 'aaronp@rubyforge.org')
end

file GENERATED_SCANNER => 'lib/scanner.rex' do |t|
  sh "frex -o #{t.name} #{t.prerequisites.first}"
end

Rake::Task[:test].prerequisites << GENERATED_SCANNER
Rake::Task[:check_manifest].prerequisites << GENERATED_SCANNER

# vim: syntax=Ruby

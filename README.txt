= ZOMG

* http://zomg.rubyforge.org/
* http://tenderlovemaking.com/

== DESCRIPTION:

ZOMG is an OMG IDL parser.  ZOMG will generate a Ruby AST from an IDL AST,
and will even generate ruby (by means of Ruby2Ruby).

== FEATURES/PROBLEMS:

* Parses IDL, generates Ruby
* Ships with OMFG the Object Management File Generator
* Ignores nested structs/unions
* Treats out/inout parameters are DIY

== SYNOPSIS:

In code:

  ZOMG::IDL.parse(File.read(ARGV[0])).to_ruby

Command line:

  $ omfg lol.idl > roflmao.rb

== REQUIREMENTS:

* ruby2ruby

== INSTALL:

* sudo gem install zomg

== LICENSE:

(The MIT License)

Copyright (c) 2008 {Aaron Patterson}[http://tenderlovemaking.com/]

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

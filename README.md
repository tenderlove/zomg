# ZOMG

* https://github.com/tenderlove/zomg/
* http://tenderlovemaking.com/

# WARNING: THIS FORK IS UNSTABLE!  I am working on specific improvements a client needs.  Once those are finished, the parts that are widely applicable will be packaged into pull requests and submitted upstream.  Do not count on it working at any point.

## DESCRIPTION:

ZOMG is an OMG IDL parser.  ZOMG will generate a Ruby AST or a hash
from an IDL AST,
and will even generate ruby (by means of Ruby2Ruby).

## FEATURES/PROBLEMS:

* Parses IDL, generates Ruby or a hash
* Ships with OMFG the Object Management File Generator
* Ignores nested structs/unions
* Treats out/inout parameters are DIY

## SYNOPSIS:

In code:

    ZOMG::IDL.parse(File.read(ARGV[0])).to_ruby

or

    ZOMG::IDL.parse(File.read(ARGV[0])).to_hash

Command line:

    $ omfg lol.idl > roflmao.rb

(Sorry, no command-line for to_hash yet,
but you can cobble that together yourself easily.)

## REQUIREMENTS:

* ruby2ruby

## INSTALL:

First do the usual:

    sudo gem install zomg

But then you _may_ have more to do.

If you try to use it and see
a NoMethodError message
about there being no such method as
`collect` for a `String`,
you need to fix a simple bug.
ZOMG depends on the gem tenderlove-frex.
Find your source code for that gem.
In the file lib/frex/rexcmd.rb,
line 18 says: `OPTIONS  =  <<-EOT`.
Simply append `.split("\n")` to that line and you'll be good to go.
(I _would_ fix this as an open source contribution but the repo is gone.)

## LICENSE:

(The MIT License)

Copyright (c) 2017 [Aaron Patterson](http://tenderlovemaking.com/)

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

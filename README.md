Linebreak
=========

[![Build Status](https://secure.travis-ci.org/aef/linebreak.png)](
https://secure.travis-ci.org/aef/linebreak)

* [Documentation][1]
* [Project][2]

   [1]: http://rdoc.info/projects/aef/linebreak/
   [2]: http://github.com/aef/linebreak/

Description
-----------

Linebreak is a Ruby library and commandline tool for conversion of text
between linebreak encoding formats of unix, windows or mac.

Earlier versions of Linebreak were called BreakVerter.

Features / Problems
-------------------

This projects tries to conform to:

* [Semantic Versioning (2.0.0-rc.1)][5]
* [Ruby Packaging Standard (0.5-draft)][6]
* [Ruby Style Guide][7]
* [Gem Packaging: Best Practices][8]

   [5]: http://semver.org/
   [6]: http://chneukirchen.github.com/rps/
   [7]: https://github.com/bbatsov/ruby-style-guide
   [8]: http://weblog.rubyonrails.org/2009/9/1/gem-packaging-best-practices

Additional facts:

* Written purely in Ruby.
* Intended to be used with Ruby 1.8.7 or higher.

Synopsis
--------

This documentation defines the public interface of the library. Don't rely
on elements marked as private. Those should be hidden in the documentation
by default.

### Loading

In most cases you want to load the library by the following command:

~~~~~ ruby
require 'linebreak'
~~~~~

In a bundler Gemfile you should use the following:

~~~~~ ruby
gem 'linebreak'
~~~~~

### Library

You can put strings or objects responding to to_s into the method and
optionally define a target linebreak encoding. The default encoding is :unix.
You can also choose :mac and :windows. Notice that the :mac encoding is
deprecated. Modern Apple machines also use :unix linebreak encoding, while
Commodore machines also use the :mac linebreak encoding.

~~~~~ ruby
windows_string = "Abcdef\r\nAbcdef\r\nAbcdef"

Aef::Linebreak.encode(windows_string, :unix)
#=> "Abcdef\nAbcdef\nAbcdef"
~~~~~

You can detect which decoding systems are used in a string:

~~~~~ ruby
mixed_unix_and_mac_string = "Abcdef\rAbcdef\nAbcdef"

Aef::Linebreak.encodings(mixed_unix_and_mac_string)
#=> #<Set: {:unix, :mac}>
~~~~~

You can also easily ensure that a string contains exactly the linebreak
encodings you expect it to contain:

~~~~~ ruby
mixed_windows_and_mac_string = "Abcdef\r\nAbcdef\rAbcdef"

Aef::Linebreak.encoding?(mixed_windows_and_mac_string, :windows)
#=> false

Aef::Linebreak.encoding?(mixed_windows_and_mac_string, :windows, :mac)
#=> true
~~~~~

Note that the expected linebreak systems could also be given as an array or a
set.

Alternatively you could include Linebreak into the String class and use it in
the following way:

~~~~~ ruby
require 'aef/linebreak/string_extension'

"Abcdef\nAbcdef\nAbcdef".linebreak_encode(:mac)
#=> "Abcdef\rAbcdef\rAbcdef"

"Abcdef\r\nAbcdef\nAbcdef".linebreak_encodings
#=> #<Set: {:unix, :windows}>

"Abcdef\nAbcdef\nAbcdef".linebreak_encoding?(:unix, :windows)
#=> false

"Abcdef\nAbcdef\nAbcdef".linebreak_encoding?(:unix)
#=> true
~~~~~

### Command-line tool

The default output encoding is unix. You can also choose mac and windows.

    linebreak encode --system windows unix.txt windows.txt

If no target file is specified the output will be sent to STDOUT.

    linebreak encode --system windows mac.txt > windows.txt

You can set the default with the environment variable LINEBREAK_SYSTEM.

    export LINEBREAK_SYSTEM=mac

    linebreak encode windows.txt mac.txt

If you do not specify an output file, output will be put to STDOUT. If you also
do not specify an input file, input will be expected from STDIN.

You can also detect the linebreak systems contained in a file in the following
way:

    linebreak encodings windows_mac.txt

If you want to ensure that a file contains the exact encodings systems you
specified, you can use the following command:

    linebreak encodings --ensure unix,windows,mac unix.txt

The results will be outputted. In case of a file containing other linebreak
encoding systems there will be an exit code of 1.

It is also possible to specify multiple input files or none to expect input from
STDIN.

Requirements
------------

* Ruby 1.8.7 or higher
* user-choices for command line tool

Installation
------------

On *nix systems you may need to prefix the command with sudo to get root
privileges.

### High security (recommended)

There is a high security installation option available through rubygems. It is
highly recommended over the normal installation, although it may be a bit less
comfortable. To use the installation method, you will need my public key, which
I use for cryptographic signatures on all my gems. You can find the public key
here: http://aef.name/crypto/aef-gem.pem

Add the key to your rubygems' trusted certificates by the following command:

    gem cert --add aef-gem.pem

Now you can install the gem while automatically verifying it's signature by the
following command:

    gem install linebreak -P HighSecurity

Please notice that you may need other keys for dependent libraries, so you may
have to install dependencies manually.  

### Normal

    gem install linebreak

### Automated testing

Go into the root directory of the installed gem and run the following command
to fetch all development dependencies:

    bundle

Afterwards start the test runner:

    rake spec

If something goes wrong you should be noticed through failing examples.

Development
-----------

This software is developed in the source code management system git hosted
at github.com. You can download the most recent sourcecode through the
following command:

    git clone https://github.com/aef/linebreak.git

Help on making this software better is always very appreciated. If you want
your changes to be included in the official release, please clone my project
on github.com, create a named branch to commit and push your changes in and
send me a pull request afterwards.

Please make sure to write tests for your changes so that I won't break them
when changing other things on the library. Also notice that I can't promise
to include your changes before reviewing them.

License
-------

Copyright Alexander E. Fischer <aef@raxys.net>, 2009-2012

This file is part of Linebreak.

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
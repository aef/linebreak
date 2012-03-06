Linebreak
=========

[![Build Status](https://secure.travis-ci.org/aef/linebreak.png)](
https://secure.travis-ci.org/aef/linebreak)

* [Documentation][1]
* [Project][2]

   [1]: http://rdoc.info/projects/aef/linebreak/
   [2]: https://github.com/aef/linebreak/

Description
-----------

Linebreak is a Ruby library for conversion of text between linebreak encoding
formats of unix, windows or mac.

A command-line tool is available as separate gem named linebreak-cli.
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
* Extends core classes. This can be disabled through bare mode.
* Cryptographically signed gem and git tags

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

By default, Linebreak extends the String class to make all Strings support the
linebreak helper methods. The decision to modify Ruby's core classes should be
in the hand of the end user (e.g. the application developer). So if you don't
want the core extensions to be loaded or if you are using this library as a
component in another library you should load this library in bare mode: 

~~~~~ ruby
require 'linebreak/bare'
~~~~~

Or for bundler Gemfiles:

~~~~~ ruby
gem 'linebreak', require: 'linebreak/bare'
~~~~~

### Library

You can convert Strings to a target linebreak encoding. The default encoding is
:unix. You can also choose :mac and :windows. Notice that the :mac encoding is
deprecated. Modern Apple machines also use :unix linebreak encoding, while
Commodore machines also use the :mac linebreak encoding.

~~~~~ ruby
windows_string = "Abcdef\r\nAbcdef\r\nAbcdef"

windows_string.linebreak_encode(:unix)
#=> "Abcdef\nAbcdef\nAbcdef"
~~~~~

You can detect which decoding systems are used in a String:

~~~~~ ruby
mixed_unix_and_mac_string = "Abcdef\rAbcdef\nAbcdef"

mixed_unix_and_mac_string.linebreak_encodings
#=> #<Set: {:unix, :mac}>
~~~~~

You can also easily ensure that a String contains exactly the linebreak
encodings you expect it to contain:

~~~~~ ruby
mixed_windows_and_mac_string = "Abcdef\r\nAbcdef\rAbcdef"

mixed_windows_and_mac_string.linebreak_encoding?(:windows)
#=> false

mixed_windows_and_mac_string.linebreak_encoding?(:windows, :mac)
#=> true
~~~~~

Note that the expected linebreak systems could also be given as an Array or a
Set.

If you prefer not the use the core extensions (e.g. in bare mode) you can use
this library in the following way: 

~~~~~ ruby
Aef::Linebreak.encode("Abcdef\nAbcdef\nAbcdef", :mac)
#=> "Abcdef\rAbcdef\rAbcdef"

Aef::Linebreak.encodings("Abcdef\r\nAbcdef\nAbcdef")
#=> #<Set: {:unix, :windows}>

Aef::Linebreak.encoding?("Abcdef\nAbcdef\nAbcdef", :unix, :windows)
#=> false

Aef::Linebreak.encoding?("Abcdef\nAbcdef\nAbcdef", :unix)
#=> true
~~~~~

Or you can manually extend a String to support the linebreak helper methods like
this:

~~~~~ ruby
some_string.extend Aef::Linebreak
~~~~~

Requirements
------------

* Ruby 1.8.7 or higher

Installation
------------

On *nix systems you may need to prefix the command with sudo to get root
privileges.

### High security (recommended)

There is a high security installation option available through rubygems. It is
highly recommended over the normal installation, although it may be a bit less
comfortable. To use the installation method, you will need my [gem signing
public key][9], which I use for cryptographic signatures on all my gems.

Add the key to your rubygems' trusted certificates by the following command:

    gem cert --add aef-gem.pem

Now you can install the gem while automatically verifying it's signature by the
following command:

    gem install linebreak -P HighSecurity

Please notice that you may need other keys for dependent libraries, so you may
have to install dependencies manually.

   [9]: http://aef.name/crypto/aef-gem.pem

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

The final commit before each released gem version will be marked by a tag
named like the version with a prefixed lower-case "v", as required by Semantic
Versioning. Every tag will be signed by my [OpenPGP public key][10] which
enables you to verify your copy of the code cryptographically.

   [10]: http://aef.name/crypto/aef-openpgp.pem

Add the key to your GnuPG keyring by the following command:

    gpg --import aef-openpgp.asc

This command will tell you if your code is of integrity and authentic:

    git tag -v [TAG NAME]

Help on making this software better is always very appreciated. If you want
your changes to be included in the official release, please clone my project
on github.com, create a named branch to commit and push your changes into and
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

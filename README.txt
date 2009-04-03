= BreakVerter

* Project: https://rubyforge.org/projects/aef/
* RDoc: http://aef.rubyforge.org/breakverter/

== DESCRIPTION:

BreakVerter is able to convert a string encoded in unix, windows or mac format
to any of these formats.

== FEATURES/PROBLEMS:

* Usable as library and commandline tool
* Tested and fully working on:
  * Windows XP i386 (Ruby 1.8.6)
  * Ubuntu Linux 8.10 i386_64 (Ruby 1.8.7 and 1.9.1p0)
* The commandline tool doesn't work with Ruby 1.9.x because the user-choices gem is not yet updated. A patch is available here: https://rubyforge.org/tracker/index.php?func=detail&aid=24307&group_id=4192&atid=16176

== SYNOPSIS:

* In commandline:

  breakverter -o windows unix.txt windows.txt

The default output encoding is unix. You can set the default with the environment variable BREAKVERTER_OUTPUT. If no target file is specified the output will be sent to STDOUT.

* As library:

  require 'breakverter'

  windows_string = "Abcdef\r\nAbcdef\r\nAbcdef"

  BreakVerter.convert(windows_string, :unix) #=> "Abcdef\nAbcdef\nAbcdef"

== REQUIREMENTS:

* user-choices (Only for the commandline tool)
* rspec (Only for automated testing)

== INSTALL:

* gem install breakverter
* gem install user-choices (only for commandline tool)

== LICENSE:

Copyright 2009 Alexander E. Fischer <aef@raxys.net>

This file is part of BreakVerter.

BreakVerter is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.


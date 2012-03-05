# Copyright 2009 Alexander E. Fischer <aef@raxys.net>
#
# This file is part of Linebreak.
#
# Linebreak is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Helper file to allow loading by gem name. Includes mixin Aef::Linebreak
# into String to provide linebreak helper methods and creates an alias for
# Aef::Linebreak named simply Linebreak if this name isn't used otherwise.

require 'aef/linebreak'

String.call(:include, Aef::Linebreak)

::Linebreak = Aef::Linebreak unless defined?(::Linebreak)

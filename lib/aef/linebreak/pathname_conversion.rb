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

# This class adds the type :pathname to user-choices
class Aef::Linebreak::ConversionToPathname < UserChoices::Conversion
  def self.described_by?(conversion_tag)
    conversion_tag == :pathname
  end

  def description
    "a pathname"
  end

  def suitable?(actual)
    true
  end

  def convert(value)
    case value
    when Array
      pathnames = []
      
      value.each {|path| pathnames << Pathname(path) }

      pathnames
    else
      Pathname(value)
    end
  end
end

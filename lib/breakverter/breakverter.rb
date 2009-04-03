# Copyright 2009 Alexander E. Fischer <aef@raxys.net>
#
# This file is part of BreakVerter.
#
# BreakVerter is free software: you can redistribute it and/or modify
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

# BreakVerter is Ruby library and commandline tool for conversion of text
# between linebreak encoding formats of unix, windows or mac.
module Aef::BreakVerter
  VERSION = '1.1.2'
  
  BREAKS = {
    :unix => "\n",
    :windows => "\r\n",
    :mac => "\r"
  }

  # Convert a file with any linebreak encoding to a specific linebreak encoding.
  #
  # If given output_encoding is not a key of BREAKS, all linebreaks are replaced
  # with output_encoding's content itself.
  def self.convert(input, output_encoding = :unix)
    if input.respond_to?(:to_s) then input = input.to_s
    else raise 'Input has to be a string or must support to_s' end

    input.gsub(/\r(?:\n)?|\n/, BREAKS[output_encoding] || output_encoding)
  end

  # Shortcut for direct receiver conversion, for example if BreakVerter is
  # included into the string class
  def linebreaks(output_encoding = :unix)
    Aef::BreakVerter.convert(self, output_encoding)
  end
end

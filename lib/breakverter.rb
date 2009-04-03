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

# Module containing a single method
module BreakVerter
  VERSION = '1.1.1'
  
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
end
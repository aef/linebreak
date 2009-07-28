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
#
# If you want to use the String extension methods, simply use the following
# command:
#
#   require 'breakverter/string_extension'
module Aef::BreakVerter
  VERSION = '1.3.0'
  
  BREAK_BY_SYSTEM = {
    :unix => "\n",
    :windows => "\r\n",
    :mac => "\r"
  }

  SYSTEM_BY_BREAK = BREAK_BY_SYSTEM.invert

  BREAK_REGEXP = /(\r\n|[\r\n])/

  # Detects encoding systems of a string.
  #
  # Returns a Set with symbols of all encoding systems existent in the string.
  def self.encodings(input)
    if input.respond_to?(:to_s) then input = input.to_s
    else raise ArgumentError, 'Input needs to be a string or must support to_s' end

    occurences = Set.new

    input.scan(BREAK_REGEXP).each do |linebreak|
      occurences << SYSTEM_BY_BREAK[linebreak.first]
    end

    occurences
  end

  # Checks whether a string includes linebreaks of all the given encoding
  # systems.
  #
  # One or more systems can be given as an array or an argument list of symbols.
  #
  # Returns true or false.
  def self.encoding?(input, *encodings)
    systems = BREAK_BY_SYSTEM.keys
    
    encodings.flatten!
    encodings.each do |encoding|
      unless systems.include?(encoding)
        raise ArgumentError,
          %{Invalid encoding system. Available systems: #{systems.join(', ')}. Arguments are expected as symbols or an array of symbols.}
      end
    end

    Aef::BreakVerter.encodings(input) == Set.new(encodings)
  end

  # Create a copy of a string with all the string's linebreaks replaced by
  # linebreaks of a specific system or a given replacement.
  #
  # If given output_encoding is not a key of BREAK_BY_SYSTEM, all linebreaks
  # are replaced with output_encoding's content itself.
  def self.encode(input, system_or_replacement = :unix)
    if input.respond_to?(:to_s) then input = input.to_s
    else raise ArgumentError, 'Input needs to be a string or must support to_s' end

    input.gsub(BREAK_REGEXP,
      BREAK_BY_SYSTEM[system_or_replacement] || system_or_replacement)
  end

  # Detects encoding systems of the string.
  #
  # Returns a Set with symbols of all encoding systems existent in the string.
  #
  # This method is supposed to be used as a method of String.
  def linebreak_encodings
    Aef::BreakVerter.encodings(self)
  end

  # Checks whether the string includes linebreaks of all the given encoding
  # systems.
  #
  # One or more systems can be given as an array or an argument list of symbols.
  #
  # This method is supposed to be used as a method of String.
  def linebreak_encoding?(*encodings)
    Aef::BreakVerter.encoding?(self, encodings)
  end

  # Create a copy of the string with all the string's linebreaks replaced by
  # linebreaks of a specific system or a given replacement.
  #
  # If given output_encoding is not a key of BREAK_BY_SYSTEM, all linebreaks
  # are replaced with output_encoding's content itself.
  #
  # This method is supposed to be used as a method of String.
  def linebreak_encode(system_or_replacement = :unix)
    Aef::BreakVerter.encode(self, system_or_replacement)
  end
end

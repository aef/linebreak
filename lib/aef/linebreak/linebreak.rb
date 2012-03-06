# encoding: UTF-8
=begin
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
=end

require 'pathname'
require 'set'

# Linebreak is Ruby library and commandline tool for conversion of text
# between linebreak encoding formats of unix, windows or mac.
#
# If you want to use the String extension methods, simply use the following
# command:
#
#   require 'aef/linebreak/string_extension'
module Aef::Linebreak
  autoload :ConversionToPathname, 'aef/linebreak/pathname_conversion'
  autoload :EncodeCommand,        'aef/linebreak/commands/encode'
  autoload :EncodingsCommand,     'aef/linebreak/commands/encodings'
  autoload :VersionCommand,       'aef/linebreak/commands/version'

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

    Aef::Linebreak.encodings(input) == Set.new(encodings)
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
    Aef::Linebreak.encodings(self)
  end

  # Checks whether the string includes linebreaks of all the given encoding
  # systems.
  #
  # One or more systems can be given as an array or an argument list of symbols.
  #
  # This method is supposed to be used as a method of String.
  def linebreak_encoding?(*encodings)
    Aef::Linebreak.encoding?(self, encodings)
  end

  # Create a copy of the string with all the string's linebreaks replaced by
  # linebreaks of a specific system or a given replacement.
  #
  # If given output_encoding is not a key of BREAK_BY_SYSTEM, all linebreaks
  # are replaced with output_encoding's content itself.
  #
  # This method is supposed to be used as a method of String.
  def linebreak_encode(system_or_replacement = :unix)
    Aef::Linebreak.encode(self, system_or_replacement)
  end
end

require 'aef/linebreak/version'
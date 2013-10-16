# encoding: UTF-8
=begin
Copyright Alexander E. Fischer <aef@godobject.net>, 2009-2013

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

require 'set'
require 'aef/linebreak/version'

# Namespace for projects of Alexander E. Fischer <aef@raxys.net>.
#
# If you want to be able to simply type Example instead of Aef::Example to
# address classes in this namespace simply write the following before using the
# classes.
#
# @example Including the namespace
#   include Aef
# @author Alexander E. Fischer
module Aef

  # Namespace for the linebreak library
  module Linebreak

    # Mapping table from symbol to actual linebreak sequence
    #
    # @private
    BREAK_BY_SYSTEM = {
      :unix => "\n",
      :windows => "\r\n",
      :mac => "\r"
    }
  
    # Mapping table from actual linebreak sequence to symbol
    #
    # @private
    SYSTEM_BY_BREAK = BREAK_BY_SYSTEM.invert
  
    # Regular expression for linebreak detection and extraction
    #
    # @private
    BREAK_REGEXP = /(\r\n|[\r\n])/
  
    # Detects encoding systems of a string.
    #
    # @param [String] input a String to be analysed
    # @return [Set<Symbol>] the encoding systems present in the given String
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
    # @param [String] input a String to be analysed
    # @param [Array<Symbol>] encodings one or more encoding systems
    # @return [true, false] true if all of the given linebreak systems are
    #   present in the given String
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
    # @overload encode(input, system)
    #   @param [String] input a String as conversion template
    #   @param [:unix, :windows, :mac] system a target linebreak system
    #
    # @overload encode(input, replacement)
    #   @param [String] input a String as conversion template
    #   @param [String] replacement a String to be the replacement for all 
    #     linebreaks in the template
    def self.encode(input, system_or_replacement = :unix)
      if input.respond_to?(:to_s) then input = input.to_s
      else raise ArgumentError, 'Input needs to be a string or must support to_s' end
  
      input.gsub(BREAK_REGEXP,
        BREAK_BY_SYSTEM[system_or_replacement] || system_or_replacement)
    end
  
    # Detects encoding systems of a string.
    #
    # This method is supposed to be used as a method of String.
    #
    # @return [Set<Symbol>] the encoding systems present in the String
    def linebreak_encodings
      Aef::Linebreak.encodings(self)
    end
  
    # Checks whether a string includes linebreaks of all the given encoding
    # systems.
    #
    # This method is supposed to be used as a method of String.
    #
    # @param [Array<Symbol>] encodings one or more encoding systems
    # @return [true, false] true if all of the given linebreak systems are
    #   present in the given String
    def linebreak_encoding?(*encodings)
      Aef::Linebreak.encoding?(self, encodings)
    end
  
    # Create a copy of a string with all the string's linebreaks replaced by
    # linebreaks of a specific system or a given replacement.
    #
    # This method is supposed to be used as a method of String.
    #
    # @overload encode(system)
    #   @param [:unix, :windows, :mac] system a target linebreak system
    #
    # @overload encode(replacement)
    #   @param [String] replacement a String to be the replacement for all 
    #     linebreaks in the template
    def linebreak_encode(system_or_replacement = :unix)
      Aef::Linebreak.encode(self, system_or_replacement)
    end
  end
end

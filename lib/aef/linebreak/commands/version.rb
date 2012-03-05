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

require 'aef/linebreak/pathname_conversion'

class Aef::Linebreak::VersionCommand
  def execute
    name = 'Linebreak'
    puts "#{name} #{Aef::Linebreak::VERSION}"
    puts
    puts 'Project: https://rubyforge.org/projects/linebreak/'
    puts "RDoc: http://#{name.downcase}.rubyforge.org/"
    puts "Github: http://github.com/aef/#{name.downcase}/"
    puts
    puts 'Copyright 2009 Alexander E. Fischer <aef@raxys.net>'
    # Read and print licensing information from the top of this file
    if Gem::Version.new(RUBY_VERSION) <= Gem::Version.new('1.8.6')
      puts File.read(__FILE__).map{|line| line[2..-1]}[3..15]
    else
      puts File.read(__FILE__).lines.map{|line| line[2..-1]}[3..15]
    end
    exit false
  end
end

# Copyright 2009 Alexander E. Fischer <aef@raxys.net>
#
# This file is part of Linebreak.
#
# Linebreak is free software: you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.

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

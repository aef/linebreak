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

require 'lib/aef/linebreak' rescue LoadError require 'aef/linebreak'

class Aef::Linebreak::EncodingsCommand < UserChoices::Command
  include UserChoices

  # Prepare configuration sources
  def add_sources(builder)
    builder.add_source(CommandLineSource, :usage,
      "Usage: #$PROGRAM_NAME encodings [OPTIONS] [FILE]\n\n",
      "Detect linebreak encoding systems of a file.\n"
    )
  end

  # Define configuration options
  def add_choices(builder)
    builder.add_choice(:ensure, :type => [:string]) do |cli|
      cli.uses_option('-e', '--ensure SYSTEMLIST',
        "Verify that given encodings are existent. Separated by commas without spaces. Possible settings: #{Aef::Linebreak::BREAK_BY_SYSTEM.keys.join(', ')}.")
    end

    builder.add_choice(:files, :type => :pathname) {|cli| cli.uses_arglist}
  end

  # Manual option post processing
  def postprocess_user_choices
    if @user_choices[:ensure]
      @user_choices[:ensure] = @user_choices[:ensure].map{|string| string.to_sym }.to_set
    end

    if @user_choices[:files].empty? or @user_choices[:files].include?(Pathname('-'))
      @user_choices[:files] = [STDIN]
    end
  end

  # Main program
  def execute
    systems_by_file = {}

    @user_choices[:files].each do |file|
      unless systems_by_file[file]
        systems_by_file[file] = Set.new

        file.each_line do |line|
          systems_by_file[file] = Aef::Linebreak.encodings(line) + systems_by_file[file]
        end
      end
    end

    failed = false

    systems_by_file.each do |file, systems|
      print "#{file}: " unless file == STDIN

      sorted_systems = systems.sort do |a,b|
        order = [:unix, :windows, :mac]
        order.index(a) <=> order.index(b)
      end

      print sorted_systems.join(',')

      if @user_choices[:ensure] and systems != @user_choices[:ensure]
        failed = true
        puts ' (failed)'
      else
        puts
      end
    end
    
    exit false if failed
  end
end

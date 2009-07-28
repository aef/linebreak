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

# TODO: If user-choices patch gets accepted, use :one_way => true for --version
# TODO: If user-choices patch gets accepted, use :upcase for environment variables

require 'lib/aef/linebreak/linebreak' rescue LoadError require 'aef/linebreak/linebreak'

class Aef::Linebreak::EncodeCommand < UserChoices::Command
  include UserChoices

  # Prepare configuration sources
  def add_sources(builder)
    builder.add_source(
      CommandLineSource, :usage,
      "Usage: #$PROGRAM_NAME [options] input-file [output-file]\n\n",
      "Convert a file with any linebreak encoding to a specific linebreak encoding.\n",
      "Use the environment variable LINEBREAK_OUTPUT to specify a default output encoding.\n"
    )

    builder.add_source(EnvironmentSource, :mapping,
      :output => 'LINEBREAK_OUTPUT'
    )
  end

  # Define configuration options
  def add_choices(builder)
    output_values = Aef::Linebreak::BREAK_BY_SYSTEM.keys.map{|key| key.to_s}
    builder.add_choice(:output, :default => 'unix', :type => output_values) do |cli|
      cli.uses_option('-o', '--output PLATFORM',
        "Output formatting. Possible settings: #{Aef::Linebreak::BREAK_BY_SYSTEM.keys.join(', ')}")
    end

    builder.add_choice(:filenames, :length => 0..2) {|cli| cli.uses_arglist}
  end

  # Manual option post processing
  def postprocess_user_choices
    @user_choices[:input_filename] = @user_choices[:filenames][0]
    @user_choices[:output_filename] = @user_choices[:filenames][1] || '-'
  end

  # Main program
  def execute
    unless @user_choices[:input_filename]
      warn 'No input file given'; exit false
    end

    unless File.exists?(@user_choices[:input_filename])
      warn "Input file not found (#{@user_choices[:input_filename]})"; exit false
    end

    unless File.readable?(@user_choices[:input_filename])
      warn "Input file access denied (#{@user_choices[:input_filename]})"; exit false
    end

    result = Aef::Linebreak.encode(File.read(@user_choices[:input_filename]), @user_choices[:output].to_sym)

    if @user_choices[:output_filename] == '-'
      puts result
    else
      @user_choices[:output_filename]

      unless File.writable?(File.dirname(@user_choices[:output_filename]))
        warn "Output file access denied (#{@user_choices[:output_filename]})"; exit false
      end

      File.open(@user_choices[:output_filename], 'w') {|f| f.write(result)}
    end
  end
end

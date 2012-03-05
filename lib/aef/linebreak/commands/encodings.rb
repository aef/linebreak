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

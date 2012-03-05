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

# TODO: If user-choices patch gets accepted, use :upcase for environment variables

require 'aef/linebreak/pathname_conversion'

class Aef::Linebreak::EncodeCommand < UserChoices::Command
  include UserChoices

  # Prepare configuration sources
  def add_sources(builder)
    builder.add_source(
      CommandLineSource, :usage,
      "Usage: #$PROGRAM_NAME encode [OPTIONS] [INPUT] [OUTPUT]\n\n",
      "Convert all linebreak encodings of a file.\n",
      "Use the environment variable LINEBREAK_SYSTEM to specify a default output encoding.\n"
    )

    builder.add_source(EnvironmentSource, :mapping,
      :system => 'LINEBREAK_SYSTEM'
    )
  end

  # Define configuration options
  def add_choices(builder)
    systems = Aef::Linebreak::BREAK_BY_SYSTEM.keys.map{|key| key.to_s}
    builder.add_choice(:system, :default => 'unix', :type => systems) do |cli|
      cli.uses_option('-s', '--system SYSTEM',
        "Output encoding system. Possible settings: #{systems.join(', ')}")
    end

    builder.add_choice(:files, :length => 0..2, :type => :pathname) {|cli| cli.uses_arglist}
  end

  # Manual option post processing
  def postprocess_user_choices
    if @user_choices[:files][0] and @user_choices[:files][0] != Pathname('-')
      @user_choices[:input] = @user_choices[:files][0].open('r')
    else
      @user_choices[:input] = STDIN
    end

    if @user_choices[:files][1] and @user_choices[:files][1] != Pathname('-')
      @user_choices[:output] = @user_choices[:files][1].open('w')
    else
      @user_choices[:output] = STDOUT
    end
  end

  # Main program
  def execute
    @user_choices[:input].each_line do |line|
      @user_choices[:output] << Aef::Linebreak.encode(line, @user_choices[:system].to_sym)
    end

    [:input, :output].each {|stream| @user_choices[stream].close }
  end
end

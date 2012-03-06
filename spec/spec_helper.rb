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

require 'rspec'
require 'tempfile'
require 'rbconfig'
require 'popen4'
require 'linebreak'

module LinebreakSpecHelper
  INTERPRETER = Pathname(RbConfig::CONFIG['bindir']) + RbConfig::CONFIG['ruby_install_name']
  FIXTURES_DIR = Pathname('spec/fixtures')

  def executable_path
    "#{INTERPRETER} -Ilib bin/linebreak"
  end

  def fixture_path(name)
    FIXTURES_DIR + name
  end

  def windows?
    RbConfig::CONFIG['target_os'].downcase.include?('win')
  end

  def unix_fixture
    "Abcdef\nAbcdef\nAbcdef"
  end

  def windows_fixture
    "Abcdef\r\nAbcdef\r\nAbcdef"
  end

  def mac_fixture
    "Abcdef\rAbcdef\rAbcdef"
  end

  def custom_fixture
    "AbcdeffnordAbcdeffnordAbcdef"
  end

  def none_fixture
    "AbcdefAbcdefAbcdef"
  end

  def unix_windows_fixture
    unix_fixture + windows_fixture
  end

  def windows_mac_fixture
    windows_fixture + mac_fixture
  end

  def mac_unix_fixture
    mac_fixture + unix_fixture
  end

  def unix_windows_mac_fixture
    unix_fixture + windows_fixture + mac_fixture
  end

  def version_message
    <<-EOS
Linebreak #{Aef::Linebreak::VERSION}

Project: https://github.com/aef/linebreak/
Documentation: http://rubydoc.info/aef/linebreak/

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
    EOS
  end

  def env(environment = {})
    raise ArgumentError, 'A block needs to be given' unless block_given?

    backup = {}

    environment.each do |key, value|
      key, value = key.to_s, value.to_s

      backup[key] = ENV[key]
      ENV[key] = value
    end

    result = yield

    backup.each do |key, value|
      ENV[key] = value
    end

    result
  end
end

if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('1.8.7')
  warn %{\nThe 16 specs of the "encodings" methods fail on 1.8.6 and } +
    'below because of invalid hash comparison which affects ' +
    'comparison of the result Sets. This should not be a big problem.'
end

if RUBY_PLATFORM == 'java'
  warn %{\nAll 6 specs of the "encodings" command fail because JRuby does } +
    'not support the fork method. This should only affect the specs, the ' +
    'commandline tool should still work fine.'
end

RSpec.configure do |config|
  config.include LinebreakSpecHelper
end

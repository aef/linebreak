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

require 'tempfile'
require 'rbconfig'
require 'rubygems'
require 'popen4'

require 'lib/aef/linebreak/string_extension'

module LinebreakSpecHelper
  INTERPRETER = Pathname(RbConfig::CONFIG['bindir']) + RbConfig::CONFIG['ruby_install_name']
  FIXTURES_DIR = Pathname('spec/fixtures')

  def executable_path
    "#{INTERPRETER} bin/linebreak"
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

Project: https://rubyforge.org/projects/aef/
RDoc: http://aef.rubyforge.org/linebreak/
Github: http://github.com/aef/linebreak/

Copyright 2009 Alexander E. Fischer <aef@raxys.net>

Linebreak is free software: you can redistribute it and/or modify it under the
terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <http://www.gnu.org/licenses/>.
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

if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('1.8.7')
  warn %{\nThe 16 specs of the "encodings" methods fail on 1.8.6 and } +
    'below because of invalid hash comparison which affects ' +
    'comparison of the result Sets. This should not be a big problem.'
end

if RUBY_PLATFORM == 'java'
  warn %{\nAll 6 specs of the "encodings" command fail because JRuby does } +
    'not support the fork method. This should only affect the specs, the ' +
    'commandline tool should still work fine.'
end

Spec::Runner.configure do |config|
  config.include LinebreakSpecHelper
end
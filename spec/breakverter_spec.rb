# Copyright 2009 Alexander E. Fischer <aef@raxys.net>
#
# This file is part of BreakVerter.
#
# BreakVerter is free software: you can redistribute it and/or modify
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

require 'lib/breakverter'
require 'tempfile'

require 'rubygems'
require 'sys/uname'

module BreakVerterSpecHelper
  # If there is a way to get the executable path of the currently running ruby
  # interpreter, please tell me how.
  warn 'Attention: If the ruby interpreter to be tested with is not ruby in the' +
       'default path, you have to change this manually in spec/breakverter_spec.rb'
  RUBY_PATH = 'ruby'

  def executable_path
    "#{RUBY_PATH} bin/breakverter"
  end

  def fixture_path(name)
    File.join('spec/fixtures', name)
  end

  def windows?
    Sys::Uname.sysname.downcase.include?('windows')
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
end

describe BreakVerter do
  include BreakVerterSpecHelper

  context 'library' do
    it 'should convert correctly from unix to windows format' do
      BreakVerter.convert(unix_fixture, :windows).should eql(windows_fixture)
    end

    it 'should convert correctly from unix to mac format' do
      BreakVerter.convert(unix_fixture, :mac).should eql(mac_fixture)
    end

    it 'should convert correctly from unix to a custom format' do
      BreakVerter.convert(unix_fixture, 'fnord').should eql(custom_fixture)
    end

    it 'should convert correctly from windows to unix format' do
      BreakVerter.convert(windows_fixture, :unix).should eql(unix_fixture)
    end

    it 'should convert correctly from windows to mac format' do
      BreakVerter.convert(windows_fixture, :mac).should eql(mac_fixture)
    end

    it 'should convert correctly from unix to a custom format' do
      BreakVerter.convert(windows_fixture, 'fnord').should eql(custom_fixture)
    end

    it 'should convert correctly from mac to unix format' do
      BreakVerter.convert(mac_fixture, :unix).should eql(unix_fixture)
    end

    it 'should convert correctly from mac to windows format' do
      BreakVerter.convert(mac_fixture, :windows).should eql(windows_fixture)
    end

    it 'should convert correctly from unix to a custom format' do
      BreakVerter.convert(mac_fixture, 'fnord').should eql(custom_fixture)
    end
  end

  context 'commandline tool' do
    it 'should use unix as default format' do
      `#{executable_path} #{fixture_path('windows.txt')}`.should eql(unix_fixture + "\n")
    end

    it 'should accept -o option to specify output format' do
      `#{executable_path} -o mac #{fixture_path('unix.txt')}`.should eql(mac_fixture + "\n")
    end

    it 'should also accept --output option to specify output format' do
      `#{executable_path} --output windows #{fixture_path('mac.txt')}`.should eql(windows_fixture + "\n")
    end

    it 'should abort on invalid output formats' do
      puts "\nAn error output after this line is expected behavior, simply ignore it:\n"
      `#{executable_path} -o fnord #{fixture_path('mac.txt')}`.should be_empty
    end

    it 'should accept BREAKVERTER_OUTPUT environment variable to specify output format' do
      if windows?
        `set BREAKVERTER_OUTPUT=mac`
        `#{executable_path} --output mac #{fixture_path('windows.txt')}`.should eql(mac_fixture + "\n")
      else
        `env BREAKVERTER_OUTPUT=mac #{executable_path} --output mac #{fixture_path('windows.txt')}`.should eql(mac_fixture + "\n")
      end
    end

    it 'should use output format specified with -o even if BREAKVERTER_OUTPUT environment variable is set' do
      if windows?
        `set BREAKVERTER_OUTPUT=windows`
        `#{executable_path} -o mac #{fixture_path('unix.txt')}`.should eql(mac_fixture + "\n")
      else
        `env BREAKVERTER_OUTPUT=windows #{executable_path} -o mac #{fixture_path('unix.txt')}`.should eql(mac_fixture + "\n")
      end
    end

    it 'should use a second argument as target file' do
      temp_file = Tempfile.open('breakverter_spec')
      location = temp_file.path
      temp_file.close
      temp_file.unlink

      `#{executable_path} --output windows #{fixture_path('unix.txt')} #{location}`.should be_empty

      File.read(location).should eql(windows_fixture)
      File.unlink(location)
    end
  end
end

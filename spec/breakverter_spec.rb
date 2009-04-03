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

# If there is a way to get the executable path of the currently running ruby
# interpreter, please tell me how.
warn 'Attention: If the ruby interpreter to be tested with is not ruby in the' +
     'default path, you have to change this manually in spec/breakverter_spec.rb'
RUBY_PATH = 'ruby'

module BreakVerterSpecHelper
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

  def windows?
    Sys::Uname.sysname.downcase.include?('windows')
  end
end

describe BreakVerter do
  include BreakVerterSpecHelper

  describe 'library' do
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

  describe 'commandline tool' do
    it 'should use unix as default format' do
      `#{RUBY_PATH} bin/breakverter spec/fixtures/windows.txt`.should eql(unix_fixture + "\n")
    end

    it 'should accept -o option to specify output format' do
      `#{RUBY_PATH} bin/breakverter -o mac spec/fixtures/unix.txt`.should eql(mac_fixture + "\n")
    end

    it 'should also accept --output option to specify output format' do
      `#{RUBY_PATH} bin/breakverter -o windows spec/fixtures/mac.txt`.should eql(windows_fixture + "\n")
    end

    it 'should abort on invalid output formats' do
      puts "\nAn error output after this line is expected behavior, simply ignore it:\n"
      `#{RUBY_PATH} bin/breakverter -o fnord spec/fixtures/mac.txt`.should be_empty
    end

    it 'should accept BREAKVERTER_OUTPUT environment variable to specify output format' do
      if windows?
        `set BREAKVERTER_OUTPUT=mac`
        `#{RUBY_PATH} bin/breakverter --output mac spec/fixtures/windows.txt`.should eql(mac_fixture + "\n")
      else
        `env BREAKVERTER_OUTPUT=mac #{RUBY_PATH} bin/breakverter --output mac spec/fixtures/windows.txt`.should eql(mac_fixture + "\n")
      end
    end

    it 'should use output format specified with -o even if BREAKVERTER_OUTPUT environment variable is set' do
      if windows?
        `set BREAKVERTER_OUTPUT=windows`
        `#{RUBY_PATH} bin/breakverter -o mac spec/fixtures/unix.txt`.should eql(mac_fixture + "\n")
      else
        `env BREAKVERTER_OUTPUT=windows #{RUBY_PATH} bin/breakverter -o mac spec/fixtures/unix.txt`.should eql(mac_fixture + "\n")
      end
    end

    it 'should use a second argument as target file' do
      temp_file = Tempfile.open('breakverter_spec')
      location = temp_file.path
      temp_file.close
      temp_file.unlink

      `#{RUBY_PATH} bin/breakverter --output windows spec/fixtures/unix.txt #{location}`.should be_empty

      File.read(location).should eql(windows_fixture)
      File.unlink(location)
    end
  end
end

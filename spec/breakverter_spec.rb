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

require 'tempfile'
require 'rbconfig'
require 'open3'
require 'rubygems'

require 'lib/breakverter/string_extension'

module BreakVerterSpecHelper
  INTERPRETER = Pathname(RbConfig::CONFIG['bindir']) + RbConfig::CONFIG['ruby_install_name']
  FIXTURES_DIR = Pathname('spec/fixtures')

  def executable_path
    "#{INTERPRETER} bin/breakverter"
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
end

if Gem::Version.new(RUBY_VERSION) <= Gem::Version.new('1.8.6')
  warn %{\nThe 16 specs of the "encodings" methods fail on 1.8.6 and } +
       'below because of invalid hash comparison which affects ' +
       'comparison of the result Sets. This should not be a big problem.'
end

describe Aef::BreakVerter do
  include BreakVerterSpecHelper

  context 'library' do
    describe 'method "encode"' do
      it 'should correctly work from unix to windows format' do
        Aef::BreakVerter.encode(unix_fixture, :windows).should eql(windows_fixture)
      end

      it 'should correctly work from unix to mac format' do
        Aef::BreakVerter.encode(unix_fixture, :mac).should eql(mac_fixture)
      end

      it 'should correctly work from unix to a custom format' do
        Aef::BreakVerter.encode(unix_fixture, 'fnord').should eql(custom_fixture)
      end

      it 'should correctly work from windows to unix format' do
        Aef::BreakVerter.encode(windows_fixture, :unix).should eql(unix_fixture)
      end

      it 'should correctly work from windows to mac format' do
        Aef::BreakVerter.encode(windows_fixture, :mac).should eql(mac_fixture)
      end

      it 'should correctly work from unix to a custom format' do
        Aef::BreakVerter.encode(windows_fixture, 'fnord').should eql(custom_fixture)
      end

      it 'should correctly work from mac to unix format' do
        Aef::BreakVerter.encode(mac_fixture, :unix).should eql(unix_fixture)
      end

      it 'should correctly work from mac to windows format' do
        Aef::BreakVerter.encode(mac_fixture, :windows).should eql(windows_fixture)
      end

      it 'should correctly work from unix to a custom format' do
        Aef::BreakVerter.encode(mac_fixture, 'fnord').should eql(custom_fixture)
      end
    end

    describe 'method "encodings"' do
      it 'should detect unix format' do
        Aef::BreakVerter.encodings(unix_fixture).should eql([:unix].to_set)
      end

      it 'should detect windows format' do
        Aef::BreakVerter.encodings(windows_fixture).should eql([:windows].to_set)
      end

      it 'should detect mac format' do
        Aef::BreakVerter.encodings(mac_fixture).should eql([:mac].to_set)
      end

      it 'should detect mixed unix and windows format' do
        Aef::BreakVerter.encodings(unix_windows_fixture).should eql([:unix, :windows].to_set)
      end

      it 'should detect mixed windows and mac format' do
        Aef::BreakVerter.encodings(windows_mac_fixture).should eql([:windows, :mac].to_set)
      end

      it 'should detect mixed mac and unix format' do
        Aef::BreakVerter.encodings(mac_unix_fixture).should eql([:mac, :unix].to_set)
      end

      it 'should detect mixed unix, windows and mac format' do
        Aef::BreakVerter.encodings(unix_windows_mac_fixture).should eql([:unix, :windows, :mac].to_set)
      end

      it 'should detect correctly strings without linebreaks' do
        Aef::BreakVerter.encodings(none_fixture).should eql(Set.new)
      end
    end

    describe 'method "encoding?"' do
      system_combinations = [
        :unix,
        :windows,
        :mac,
        :unix_windows,
        :windows_mac,
        :mac_unix,
        :unix_windows_mac
      ]

      system_combinations.each do |system_combination|
        system_combinations.each do |fixture_systems|

          expected_systems = system_combination.to_s.split('_').inject([]) do |systems, system|
            systems << system.to_sym
          end

          it "should respond correctly for #{expected_systems.join(' and ')} encoding" do
            fixture = send "#{fixture_systems}_fixture"

            result = Aef::BreakVerter.encoding?(fixture, expected_systems)

            if system_combination == fixture_systems
              result.should be_true
            else
              result.should be_false
            end
          end

          if expected_systems.size > 1
            it "should respond correctly for #{expected_systems.join(' and ')} encoding (using argument list)" do
              fixture = send "#{fixture_systems}_fixture"

              result = Aef::BreakVerter.encoding?(fixture, *expected_systems)

              if system_combination == fixture_systems
                result.should be_true
              else
                result.should be_false
              end
            end
          end
        end
      end

    end
  end

  context 'string extension' do
    describe 'method "encode"' do
      it 'should correctly work from unix to windows format' do
        unix_fixture.linebreak_encode(:windows).should eql(windows_fixture)
      end

      it 'should correctly work from unix to mac format' do
        unix_fixture.linebreak_encode(:mac).should eql(mac_fixture)
      end

      it 'should correctly work from unix to a custom format' do
        unix_fixture.linebreak_encode('fnord').should eql(custom_fixture)
      end

      it 'should correctly work from windows to unix format' do
        windows_fixture.linebreak_encode(:unix).should eql(unix_fixture)
      end

      it 'should correctly work from windows to mac format' do
        windows_fixture.linebreak_encode(:mac).should eql(mac_fixture)
      end

      it 'should correctly work from unix to a custom format' do
        windows_fixture.linebreak_encode('fnord').should eql(custom_fixture)
      end

      it 'should correctly work from mac to unix format' do
        mac_fixture.linebreak_encode(:unix).should eql(unix_fixture)
      end

      it 'should correctly work from mac to windows format' do
        mac_fixture.linebreak_encode(:windows).should eql(windows_fixture)
      end

      it 'should correctly work from unix to a custom format' do
        mac_fixture.linebreak_encode('fnord').should eql(custom_fixture)
      end
    end

    describe 'method "encodings"' do
      it 'should detect unix format' do
        unix_fixture.linebreak_encodings.should eql([:unix].to_set)
      end

      it 'should detect windows format' do
        windows_fixture.linebreak_encodings.should eql([:windows].to_set)
      end

      it 'should detect mac format' do
        mac_fixture.linebreak_encodings.should eql([:mac].to_set)
      end

      it 'should detect mixed unix and windows format' do
        unix_windows_fixture.linebreak_encodings.should eql([:unix, :windows].to_set)
      end

      it 'should detect mixed windows and mac format' do
        windows_mac_fixture.linebreak_encodings.should eql([:windows, :mac].to_set)
      end

      it 'should detect mixed mac and unix format' do
        mac_unix_fixture.linebreak_encodings.should eql([:mac, :unix].to_set)
      end

      it 'should detect mixed unix, windows and mac format' do
        unix_windows_mac_fixture.linebreak_encodings.should eql([:unix, :windows, :mac].to_set)
      end

      it 'should detect correctly strings without linebreaks' do
        none_fixture.linebreak_encodings.should eql(Set.new)
      end
    end

    describe 'method "encoding?"' do
      system_combinations = [
        :unix,
        :windows,
        :mac,
        :unix_windows,
        :windows_mac,
        :mac_unix,
        :unix_windows_mac
      ]

      system_combinations.each do |system_combination|
        system_combinations.each do |fixture_systems|

          expected_systems = system_combination.to_s.split('_').inject([]) do |systems, system|
            systems << system.to_sym
          end

          it "should respond correctly for #{expected_systems.join(' and ')} encoding" do
            fixture = send "#{fixture_systems}_fixture"

            result = fixture.linebreak_encoding?(expected_systems)

            if system_combination == fixture_systems
              result.should be_true
            else
              result.should be_false
            end
          end

          if expected_systems.size > 1
            it "should respond correctly for #{expected_systems.join(' and ')} encoding (using argument list)" do
              fixture = send "#{fixture_systems}_fixture"

              result = fixture.linebreak_encoding?(*expected_systems)

              if system_combination == fixture_systems
                result.should be_true
              else
                result.should be_false
              end
            end
          end
        end
      end

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
      Open3.popen3("#{executable_path} -o fnord #{fixture_path('mac.txt')}") do |stdin, stdout, stderr|
        stdout.read.should be_empty
        stderr.read.should_not be_empty
      end
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

    it 'should display correct version and licensing information with the --version switch' do
      message = <<-EOS
BreakVerter #{Aef::BreakVerter::VERSION}

Project: https://rubyforge.org/projects/aef/
RDoc: http://aef.rubyforge.org/breakverter/
Github: http://github.com/aef/breakverter/

Copyright 2009 Alexander E. Fischer <aef@raxys.net>

BreakVerter is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
      EOS
      
      `#{executable_path} --version`.should eql(message)
    end
  end
end
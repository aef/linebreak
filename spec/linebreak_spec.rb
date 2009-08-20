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

require 'spec/spec_helper'

describe Aef::Linebreak do
  include LinebreakSpecHelper

  context 'library' do
    describe 'method "encode"' do
      it 'should correctly work from unix to windows format' do
        Aef::Linebreak.encode(unix_fixture, :windows).should eql(windows_fixture)
      end

      it 'should correctly work from unix to mac format' do
        Aef::Linebreak.encode(unix_fixture, :mac).should eql(mac_fixture)
      end

      it 'should correctly work from unix to a custom format' do
        Aef::Linebreak.encode(unix_fixture, 'fnord').should eql(custom_fixture)
      end

      it 'should correctly work from windows to unix format' do
        Aef::Linebreak.encode(windows_fixture, :unix).should eql(unix_fixture)
      end

      it 'should correctly work from windows to mac format' do
        Aef::Linebreak.encode(windows_fixture, :mac).should eql(mac_fixture)
      end

      it 'should correctly work from unix to a custom format' do
        Aef::Linebreak.encode(windows_fixture, 'fnord').should eql(custom_fixture)
      end

      it 'should correctly work from mac to unix format' do
        Aef::Linebreak.encode(mac_fixture, :unix).should eql(unix_fixture)
      end

      it 'should correctly work from mac to windows format' do
        Aef::Linebreak.encode(mac_fixture, :windows).should eql(windows_fixture)
      end

      it 'should correctly work from unix to a custom format' do
        Aef::Linebreak.encode(mac_fixture, 'fnord').should eql(custom_fixture)
      end
    end

    describe 'method "encodings"' do
      it 'should detect unix format' do
        Aef::Linebreak.encodings(unix_fixture).should eql([:unix].to_set)
      end

      it 'should detect windows format' do
        Aef::Linebreak.encodings(windows_fixture).should eql([:windows].to_set)
      end

      it 'should detect mac format' do
        Aef::Linebreak.encodings(mac_fixture).should eql([:mac].to_set)
      end

      it 'should detect mixed unix and windows format' do
        Aef::Linebreak.encodings(unix_windows_fixture).should eql([:unix, :windows].to_set)
      end

      it 'should detect mixed windows and mac format' do
        Aef::Linebreak.encodings(windows_mac_fixture).should eql([:windows, :mac].to_set)
      end

      it 'should detect mixed mac and unix format' do
        Aef::Linebreak.encodings(mac_unix_fixture).should eql([:mac, :unix].to_set)
      end

      it 'should detect mixed unix, windows and mac format' do
        Aef::Linebreak.encodings(unix_windows_mac_fixture).should eql([:unix, :windows, :mac].to_set)
      end

      it 'should detect correctly strings without linebreaks' do
        Aef::Linebreak.encodings(none_fixture).should eql(Set.new)
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

          it "should correctly ensure #{expected_systems.join(' and ')} encoding (input: #{fixture_systems.to_s.split('_').join(' and ')})" do
            fixture = send "#{fixture_systems}_fixture"

            result = Aef::Linebreak.encoding?(fixture, expected_systems)

            if system_combination == fixture_systems
              result.should be_true
            else
              result.should be_false
            end
          end

          if expected_systems.size > 1
            it "should correctly ensure #{expected_systems.join(' and ')} encoding (input: #{fixture_systems.to_s.split('_').join(' and ')}; using argument list)" do
              fixture = send "#{fixture_systems}_fixture"

              result = Aef::Linebreak.encoding?(fixture, *expected_systems)

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
    describe 'method "linebreak_encode"' do
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

    describe 'method "linebreak_encodings"' do
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

    describe 'method "linebreak_encoding?"' do
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

          it "should correctly ensure #{expected_systems.join(' and ')} encoding (input: #{fixture_systems.to_s.split('_').join(' and ')})" do
            fixture = send "#{fixture_systems}_fixture"

            result = fixture.linebreak_encoding?(expected_systems)

            if system_combination == fixture_systems
              result.should be_true
            else
              result.should be_false
            end
          end

          if expected_systems.size > 1
            it "should correctly ensure #{expected_systems.join(' and ')} encoding (input: #{fixture_systems.to_s.split('_').join(' and ')}; using argument list)" do
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
    describe '"version" command' do
      it 'should display correct version and licensing information with the version argument' do
        `#{executable_path} version`.should eql(version_message)
      end

      it 'should display correct version and licensing information with the --version argument' do
        `#{executable_path} --version`.should eql(version_message)
      end

      it 'should display correct version and licensing information with the -v argument' do
        `#{executable_path} -v`.should eql(version_message)
      end

      it 'should display correct version and licensing information with the -V argument' do
        `#{executable_path} -V`.should eql(version_message)
      end
    end

    describe '"encode" command' do
      it 'should use unix as default format' do
        `#{executable_path} encode #{fixture_path('windows.txt')}`.should eql(unix_fixture)
      end

      it 'should accept -s option to specify output format' do
        `#{executable_path} encode -s mac #{fixture_path('unix.txt')}`.should eql(mac_fixture)
      end

      it 'should also accept --system option to specify output format' do
        `#{executable_path} encode --system windows #{fixture_path('mac.txt')}`.should eql(windows_fixture)
      end

      it 'should abort on invalid output formats' do
        POpen4.popen4("#{executable_path} encode -s fnord #{fixture_path('mac.txt')}") do |stdout, stderr, stdin, pid|
          stdout.read.should be_empty
          stderr.read.should_not be_empty
        end
      end

      it 'should accept LINEBREAK_SYSTEM environment variable to specify output format' do
        env(:LINEBREAK_SYSTEM => 'mac') do
          `#{executable_path} encode #{fixture_path('windows.txt')}`.should eql(mac_fixture)
        end
      end

      it 'should use output format specified with -s even if LINEBREAK_SYSTEM environment variable is set' do
        env(:LINEBREAK_SYSTEM => 'windows') do
          `#{executable_path} encode -s mac #{fixture_path('unix.txt')}`.should eql(mac_fixture)
        end
      end

      it 'should use a second argument as target file' do
        temp_file = Tempfile.open('linebreak_spec')
        location = Pathname(temp_file.path)
        temp_file.close
        location.delete

        `#{executable_path} encode --system windows #{fixture_path('unix.txt')} #{location}`.should be_empty

        location.read.should eql(windows_fixture)
        location.delete
      end
    end

    describe '"encodings" command' do
      it "should correctly detect the linebreak encodings of a file" do
        POpen4.popen4("#{executable_path} encodings #{fixture_path('mac.txt')}") do |stdout, stderr, stdin, pid|
          stdout.read.should eql("#{fixture_path('mac.txt')}: mac\n")
        end.exitstatus.should eql(0)
      end

      it "should correctly detect the linebreak encodings of multiple files" do
        files = %w{unix_windows.txt windows_mac.txt mac_unix.txt unix_windows_mac.txt}
        files = files.map{|file| fixture_path(file)}

        POpen4.popen4("#{executable_path} encodings #{files.join(' ')}") do |stdout, stderr, stdin, pid|
          output = stdout.read
          output.should include("#{files[0]}: unix,windows\n")
          output.should include("#{files[1]}: windows,mac\n")
          output.should include("#{files[2]}: unix,mac\n")
          output.should include("#{files[3]}: unix,windows,mac\n")
        end.exitstatus.should eql(0)
      end

      it "should correctly ensure the linebreak encodings of a valid file" do
        POpen4.popen4("#{executable_path} encodings --ensure unix #{fixture_path('unix.txt')}") do |stdout, stderr, stdin, pid|
          output = stdout.read
          output.should eql("#{fixture_path('unix.txt')}: unix\n")
        end.exitstatus.should eql(0)
      end

      it "should correctly ensure the linebreak encodings of an invalid file" do
        POpen4.popen4("#{executable_path} encodings --ensure mac #{fixture_path('unix_windows.txt')}") do |stdout, stderr, stdin, pid|
          output = stdout.read
          output.should eql("#{fixture_path('unix_windows.txt')}: unix,windows (failed)\n")
        end.exitstatus.should eql(1)
      end

      it "should correctly ensure the linebreak encodings of multiple files" do
        files = %w{unix_windows.txt windows_mac.txt mac_unix.txt unix_windows_mac.txt}
        files = files.map{|file| fixture_path(file)}

        POpen4.popen4("#{executable_path} encodings --ensure windows,unix #{files.join(' ')}") do |stdout, stderr, stdin, pid|
          output = stdout.read
          output.should include("#{files[0]}: unix,windows\n")
          output.should_not include("#{files[0]}: unix,windows (failed)\n")
          output.should include("#{files[1]}: windows,mac (failed)\n")
          output.should include("#{files[2]}: unix,mac (failed)\n")
          output.should include("#{files[3]}: unix,windows,mac (failed)\n")
        end.exitstatus.should eql(1)
      end
    end
  end
end

# encoding: UTF-8
=begin
Copyright Alexander E. Fischer <aef@godobject.net>, 2009-2013

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

require 'spec_helper'

describe Aef::Linebreak do
  let(:unix_fixture)    { "Abcdef\nAbcdef\nAbcdef" }
  let(:windows_fixture) { "Abcdef\r\nAbcdef\r\nAbcdef" }
  let(:mac_fixture)     { "Abcdef\rAbcdef\rAbcdef" }
  let(:custom_fixture)  { "AbcdeffnordAbcdeffnordAbcdef" }
  let(:none_fixture)    { "AbcdefAbcdefAbcdef" }
  let(:unix_windows_fixture) { unix_fixture + windows_fixture }
  let(:windows_mac_fixture)  { windows_fixture + mac_fixture }
  let(:mac_unix_fixture)     { mac_fixture + unix_fixture }
  let(:unix_windows_mac_fixture) { unix_fixture + windows_fixture + mac_fixture }

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
end

# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/breakverter.rb'

Hoe.new('breakverter', BreakVerter::VERSION) do |p|
  p.rubyforge_name = 'aef'
  p.developer('Alexander E. Fischer', 'aef@raxys.net')
  p.extra_dev_deps = %w{rspec user-choices sys-uname}
  p.testlib = 'spec'
  p.test_globs = ['spec/**/*_spec.rb']
end

# vim: syntax=Ruby

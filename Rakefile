# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.spec('linebreak') do
  developer('Alexander E. Fischer', 'aef@raxys.net')

  self.rubyforge_name = 'linebreak'
  self.extra_dev_deps = {
    'user-choices' => '>= 1.1.6',
    'rspec' => '>= 1.2.8',
    'popen4' => '>= 0.1.2'
  }
  self.url = 'https://rubyforge.org/projects/linebreak/'
  self.readme_file = 'README.rdoc'
  self.extra_rdoc_files = %w{README.rdoc}
  self.spec_extras = {
    :rdoc_options => ['--main', 'README.rdoc', '--inline-source', '--line-numbers', '--title', 'Linebreak']
  }
  self.rspec_options = ['--options', 'spec/spec.opts']
  self.remote_rdoc_dir = ''
end

# vim: syntax=Ruby

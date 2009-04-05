# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{breakverter}
  s.version = "1.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alexander E. Fischer"]
  s.date = %q{2009-04-05}
  s.default_executable = %q{breakverter}
  s.description = %q{BreakVerter is a Ruby library and commandline tool for conversion of text between linebreak encoding formats of unix, windows or mac.}
  s.email = ["aef@raxys.net"]
  s.executables = ["breakverter"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "COPYING.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "COPYING.txt", "Rakefile", "bin/breakverter", "lib/breakverter.rb", "lib/breakverter/breakverter.rb", "spec/breakverter_spec.rb", "spec/fixtures/unix.txt", "spec/fixtures/windows.txt", "spec/fixtures/mac.txt"]
  s.has_rdoc = true
  s.homepage = %q{https://rubyforge.org/projects/aef/}
  s.rdoc_options = ["--main", "README.rdoc", "--inline-source", "--line-numbers", "--title", "BreakVerter"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{aef}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{BreakVerter is a Ruby library and commandline tool for conversion of text between linebreak encoding formats of unix, windows or mac.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<user-choices>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<sys-uname>, [">= 0"])
      s.add_development_dependency(%q<hoe>, [">= 1.11.0"])
    else
      s.add_dependency(%q<user-choices>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<sys-uname>, [">= 0"])
      s.add_dependency(%q<hoe>, [">= 1.11.0"])
    end
  else
    s.add_dependency(%q<user-choices>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<sys-uname>, [">= 0"])
    s.add_dependency(%q<hoe>, [">= 1.11.0"])
  end
end

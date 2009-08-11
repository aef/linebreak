# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{linebreak}
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alexander E. Fischer"]
  s.cert_chain = ["/home/dimedo/.gem/gem-public_cert.pem"]
  s.date = %q{2009-08-11}
  s.default_executable = %q{linebreak}
  s.description = %q{Linebreak is a Ruby library and commandline tool for conversion of text
between linebreak encoding formats of unix, windows or mac.}
  s.email = ["aef@raxys.net"]
  s.executables = ["linebreak"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "COPYING.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "COPYING.txt", "Rakefile", "bin/linebreak", "lib/aef/linebreak.rb", "lib/aef/linebreak/string_extension.rb", "lib/aef/linebreak/commands/encode.rb", "lib/aef/linebreak/commands/encodings.rb", "lib/aef/linebreak/commands/version.rb", "lib/aef/linebreak/pathname_conversion.rb", "lib/aef/linebreak/linebreak.rb", "lib/aef.rb", "spec/linebreak_spec.rb", "spec/fixtures/unix.txt", "spec/fixtures/windows.txt", "spec/fixtures/mac.txt", "spec/fixtures/unix_windows.txt", "spec/fixtures/windows_mac.txt", "spec/fixtures/mac_unix.txt", "spec/fixtures/unix_windows_mac.txt"]
  s.homepage = %q{https://rubyforge.org/projects/aef/}
  s.rdoc_options = ["--main", "README.rdoc", "--inline-source", "--line-numbers", "--title", "Linebreak"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{linebreak}
  s.rubygems_version = %q{1.3.4}
  s.signing_key = %q{/home/dimedo/.gem/gem-private_key.pem}
  s.summary = %q{Linebreak is a Ruby library and commandline tool for conversion of text between linebreak encoding formats of unix, windows or mac.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<user-choices>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<popen4>, [">= 0"])
      s.add_development_dependency(%q<hoe>, [">= 2.3.2"])
    else
      s.add_dependency(%q<user-choices>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<popen4>, [">= 0"])
      s.add_dependency(%q<hoe>, [">= 2.3.2"])
    end
  else
    s.add_dependency(%q<user-choices>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<popen4>, [">= 0"])
    s.add_dependency(%q<hoe>, [">= 2.3.2"])
  end
end

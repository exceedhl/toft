# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "toft/version"

Gem::Specification.new do |s|
  s.name        = "toft"
  s.version     = Toft::VERSION
  s.authors     = ["Huang Liang"]
  s.email       = ["exceedhl@gmail.com"]
  s.homepage    = "https://github.com/exceedhl/toft"
  s.summary     = %q{toft aims to help test infrastructure code such as chef}
  s.description = %q{toft currently support testing chef, shell scripts using cucumber on lxc on ubuntu}

  s.rubyforge_project = "toft"

  s.files         = `git ls-files -- {features,fixtures,Gemfile,Gemfile.lock,Rakefile,lib,scripts,spec}`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "vagrant", ">=0.8.7"
  s.add_runtime_dependency "net-ssh"
end

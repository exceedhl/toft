# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tuft/version"

Gem::Specification.new do |s|
  s.name        = "tuft"
  s.version     = Tuft::VERSION
  s.authors     = ["Huang Liang"]
  s.email       = ["exceedhl@gmail.com"]
  s.homepage    = "https://github.com/exceedhl/tuft"
  s.summary     = %q{tuft aims to help test infrastructure code such as chef}
  s.description = %q{tuft currently support testing chef, shell scripts using cucumber on lxc on ubuntu}

  s.rubyforge_project = "tuft"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "cucumber"
  s.add_runtime_dependency "net-ssh"
end

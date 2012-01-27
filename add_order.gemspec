# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'add_order/version'

Gem::Specification.new do |s|
  s.name        = 'add_order'
  s.version     = AddOrder::VERSION
  s.authors     = ['Aaron Lasseigne']
  s.email       = ['alasseigne@sei-mi.com']
  s.homepage    = 'https://github.com/sei-mi/add_order'
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = 'add_order'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'rails', '>= 3.1'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'sqlite3'
end

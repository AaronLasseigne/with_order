# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'with_order/version'

Gem::Specification.new do |s|
  s.name        = 'with_order'
  s.version     = WithOrder::VERSION
  s.authors     = ['Aaron Lasseigne']
  s.email       = ['aaron.lasseigne@gmail.com']
  s.homepage    = 'https://github.com/AaronLasseigne/with_order'
  s.summary     = %q{Add ordering to lists, tables, etc.}
  s.description = %q{Add ordering to lists, tables, etc.}

  s.rubyforge_project = 'with_order'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'rails', '>= 3.1'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sqlite3'
end

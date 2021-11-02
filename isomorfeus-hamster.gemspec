# -*- encoding: utf-8 -*-
require_relative 'lib/isomorfeus/hamster/version.rb'

Gem::Specification.new do |s|
  s.name          = 'isomorfeus-hamster'
  s.version       = Isomorfeus::Hamster::VERSION

  s.authors       = ['Jan Biedermann']
  s.email         = ['jan@kursator.com']
  s.homepage      = 'http://isomorfeus.com'
  s.summary       = 'KV store and ObjectDB for Isomorfeus.'
  s.license       = 'MIT'
  s.description   = 'KV store and ObjectDB for Isomorfeus.'
  s.metadata      = { "github_repo" => "ssh://github.com/isomorfeus/gems" }
  s.files         = `git ls-files -- lib LICENSE README.md`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'oj', '~> 3.13.9'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rake-compiler'
  s.add_development_dependency 'rspec'
end

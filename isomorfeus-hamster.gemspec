# -*- encoding: utf-8 -*-
require_relative 'lib/isomorfeus/hamster/version.rb'

Gem::Specification.new do |s|
  s.name          = 'isomorfeus-hamster'
  s.version       = Isomorfeus::Hamster::VERSION

  s.authors       = ['Jan Biedermann']
  s.email         = ['jan@kursator.com']
  s.homepage      = 'https://isomorfeus.com'
  s.summary       = 'KV store and ObjectDB for Isomorfeus.'
  s.license       = 'MIT'
  s.description   = 'KV store and ObjectDB for Isomorfeus.'
  s.metadata      = {
                      "github_repo" => "ssh://github.com/isomorfeus/gems",
                      "source_code_uri" => "https://github.com/isomorfeus/isomorfeus-hamster"
                    }
  s.files         = `git ls-files -- lib ext LICENSE README.md`.split("\n")
  s.require_paths = ['lib']
  s.extensions    = %w(ext/isomorfeus_hamster_ext/extconf.rb)
  s.required_ruby_version = '>= 3.0.0'

  s.add_dependency 'oj', '~> 3.13.11'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rake-compiler'
  s.add_development_dependency 'rspec'
end

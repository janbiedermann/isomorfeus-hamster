require 'bundler'
require 'bundler/cli'
require 'bundler/cli/exec'

require_relative 'lib/isomorfeus/hamster/version'

require 'bundler/setup'
require 'rspec/core/rake_task'
require 'rake/extensiontask'

Rake::ExtensionTask.new :isomorfeus_hamster_ext

task :specs do
  raise unless system('bundle exec rspec')
end

task :push_packages do
  Rake::Task['push_packages_to_rubygems'].invoke
  Rake::Task['push_packages_to_github'].invoke
end

task :push_packages_to_rubygems do
  system("gem push isomorfeus-hamster-#{Isomorfeus::Hamster::VERSION}.gem")
end

task :push_packages_to_github do
  system("gem push --key github --host https://rubygems.pkg.github.com/isomorfeus isomorfeus-hamster-#{Isomorfeus::Hamster::VERSION}.gem")
end

task :push do
  system("git push github")
  system("git push gitlab")
  system("git push bitbucket")
  system("git push gitprep")
end

task :default => [:compile, :specs]

# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
require_relative 'lib/version'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.version = MagickPipe::VERSION
  gem.name = "magick_pipe"
  gem.homepage = "http://github.com/julik/magick_pipe"
  gem.license = "MIT"
  gem.summary = %Q{ Serialize RMagick processing steps and run them in a forked subprocess, later }
  gem.description = %Q{ Serialize RMagick processing steps and run them in a forked subprocess, later }
  gem.email = "me@julik.nl"
  gem.authors = ["Julik Tarkhanov"]
  # Remove the huge PSD
  gem.files.exclude "spec/*.psd"
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['spec'].execute
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "magick_pipe #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

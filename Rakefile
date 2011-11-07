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
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "spread"
  gem.homepage = "http://github.com/rbranson/spread"
  gem.license = "MIT"
  gem.summary = %Q{Spread runs seeds}
  gem.description = %Q{Spread runs seeds}
  gem.email = "rick@diodeware.com"
  gem.authors = ["Rick Branson"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new


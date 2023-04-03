#!/usr/bin/env rake
$LOAD_PATH << File.expand_path(__dir__)

require "aruba/platform"

require "bundler"
Bundler.setup

require 'bundler/gem_tasks'
require "cucumber/rake/task"
require "rspec/core/rake_task"

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w(--format progress)
end

RSpec::Core::RakeTask.new('spec')

desc "Run the whole test suite."
task test: [:spec, :cucumber]

task default: :test
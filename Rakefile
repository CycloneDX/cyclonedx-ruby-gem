#!/usr/bin/env rake
$LOAD_PATH << File.expand_path(__dir__)

require "aruba/platform"

require "bundler"
Bundler.setup

require 'bundler/gem_tasks'
require "cucumber/rake/task"
require "rspec/core/rake_task"
require 'rake/clean'

# Work around a bug in `rake/clean` from `rake` versions older than 13. It's 
# failing when it calls `FileUtils::rm_r` because that method needs to receive 
# the `opts` parameter as parameters instead of as a `Hash`.
module Rake
  module Cleaner
    module_function

    def cleanup(file_name, **opts)
      begin
        opts = { verbose: Rake.application.options.trace }.merge(opts)
        rm_r file_name, **opts
      rescue StandardError => ex
        puts "Failed to remove #{file_name}: #{ex}" unless file_already_gone?(file_name)
      end
    end
  end
end

# Remove the `coverage` directory when the `:clobber` task is run.
CLOBBER.include('coverage')

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w(--format progress)
end

RSpec::Core::RakeTask.new('spec')

# Run the `clobber` task when running the entire test suite, because the
# coverage information reported by `simplecov` can be skewed when a `coverage`
# directory is already present.
desc "Run the whole test suite."
task test: [:clobber, :spec, :cucumber]

task default: :test
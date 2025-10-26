# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'aruba/platform'
require 'rake/clean'

# Remove the `coverage` directory when the `:clobber` task is run.
CLOBBER.include('coverage')

# Cucumber
require 'cucumber/rake/task'

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w(--format progress)
end

# RSpec
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

# RuboCop
require 'rubocop/rake_task'

RuboCop::RakeTask.new

# Run the `clobber` task when running the entire test suite, because the
# coverage information reported by `simplecov` can be skewed when a `coverage`
# directory is already present.
desc "Run the whole test suite."
task test: [:clobber, :spec, :cucumber]

# Default Task
task default: :test

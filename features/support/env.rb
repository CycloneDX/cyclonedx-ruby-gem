# frozen_string_literal: true

# Based on https://github.com/cucumber/aruba/blob/3b1a6cea6e3ba55370c3396eef0a955aeb40f287/features/support/env.rb
# Licensed under MIT - https://github.com/cucumber/aruba/blob/3b1a6cea6e3ba55370c3396eef0a955aeb40f287/LICENSE

$LOAD_PATH.unshift File.expand_path('../../lib', __dir__)

# Has to be the first file required so that all other files show coverage information
require_relative 'simplecov_support' unless RUBY_PLATFORM.include?('java')

require 'fileutils'
require 'pathname'

require 'aruba/cucumber'
require 'rspec/expectations'

Around do |test_case, block|
  command_name = "#{test_case.location.file}:#{test_case.location.line} # #{test_case.name}"

  # Used in simplecov_setup so that each scenario has a different name and
  # their coverage results are merged instead of overwriting each other as
  # 'Cucumber Features'
  set_environment_variable 'SIMPLECOV_COMMAND_NAME', command_name.to_s

  simplecov_setup_pathname =
    Pathname.new(__FILE__).expand_path.parent.to_s

  # set environment variable so child processes will merge their coverage data
  # with parent process's coverage data.
  prepend_environment_variable 'RUBYOPT', "-I#{simplecov_setup_pathname} -rsimplecov_support "

  with_environment do
    block.call
  end
end

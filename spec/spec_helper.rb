# frozen_string_literal: true

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

unless RUBY_PLATFORM.include?('java')
  require 'simplecov'
  SimpleCov.command_name 'RSpec'

  # Run simplecov by default
  SimpleCov.start unless ENV.key? 'ARUBA_NO_COVERAGE'
end

mimic_next_major = ENV.fetch('MIMIC_NEXT_MAJOR_VERSION', 'false')
# Require via legacy path until v2.0.0, and unless testing functionality in preparation for next major release
require 'bom_builder' if mimic_next_major.casecmp?('false')
# Modern path is already covered by the legacy path, but doesn't hurt to include it twice
require 'cyclonedx/ruby'

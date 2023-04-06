# Copied from https://github.com/cucumber/aruba/blob/3b1a6cea6e3ba55370c3396eef0a955aeb40f287/spec/spec_helper.rb
# Licensed under MIT - https://github.com/cucumber/aruba/blob/3b1a6cea6e3ba55370c3396eef0a955aeb40f287/LICENSE

$LOAD_PATH << File.expand_path('../lib', __dir__)

unless RUBY_PLATFORM.include?('java')
  require 'simplecov'
  SimpleCov.command_name 'RSpec'

  # Run simplecov by default
  SimpleCov.start unless ENV.key? 'ARUBA_NO_COVERAGE'
end

# Loading support files
Dir.glob(File.expand_path('support/*.rb', __dir__)).sort.each { |f| require_relative f }
Dir.glob(File.expand_path('support/**/*.rb', __dir__)).sort.each { |f| require_relative f }

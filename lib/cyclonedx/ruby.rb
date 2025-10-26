# frozen_string_literal: true

# External gems
require 'bundler'
require 'fileutils'
require 'json'
require 'logger'
require 'nokogiri'
require 'optparse'
require 'ostruct'
require 'rest_client'
require 'securerandom'
require 'active_support/core_ext/hash'
require 'json_schemer'

# This gem
require_relative 'ruby/version'
require_relative 'bom_component' # no dependencies
require_relative 'bom_helpers' # depends on bom_component
require_relative 'bom_builder' # depends on bom_helpers

module Cyclonedx
  module Ruby
    class Error < StandardError; end
    # Your code goes here...
  end
end

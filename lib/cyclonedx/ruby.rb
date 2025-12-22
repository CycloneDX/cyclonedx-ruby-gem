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

# This gem
require_relative 'ruby/version'
require_relative 'field_accessor' # shared utility with no dependencies
require_relative 'bom_component' # depends on field_accessor
require_relative 'bom_helpers' # depends on field_accessor and bom_component
require_relative 'bom_builder' # depends on bom_helpers

module Cyclonedx
  module Ruby
    class Error < StandardError; end
    # Your code goes here...
  end
end

# This file is part of CycloneDX Ruby Gem.
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) OWASP Foundation. All Rights Reserved.
#
# frozen_string_literal: true

require 'bundler'
require 'fileutils'
require 'json'
require 'logger'
require 'nokogiri'
require 'optparse'
require 'ostruct'
require 'rest_client'
require 'securerandom'
require_relative 'bom_helpers'
require 'active_support/core_ext/hash'

class Bombuilder
  SUPPORTED_BOM_FORMATS = %w[xml json]

  def self.build(path)
    original_working_directory = Dir.pwd
    setup(path)
    specs_list
    bom = build_bom(@gems, @bom_output_format)

    begin
      @logger.info("Changing directory to the original working directory located at #{original_working_directory}")
      Dir.chdir original_working_directory
    rescue StandardError => e
      @logger.error("Unable to change directory the original working directory located at #{original_working_directory}. #{e.message}: #{e.backtrace.join('\n')}")
      abort
    end

    bom_directory = File.dirname(@bom_file_path)
    begin
      FileUtils.mkdir_p(bom_directory) unless File.directory?(bom_directory)
    rescue StandardError => e
      @logger.error("Unable to create the directory to hold the BOM output at #{@bom_directory}. #{e.message}: #{e.backtrace.join('\n')}")
      abort
    end

    begin
      @logger.info("Writing BOM to #{@bom_file_path}...")
      File.open(@bom_file_path, 'w') { |file| file.write(bom) }

      if @options[:verbose]
        @logger.info("#{@gems.size} gems were written to BOM located at #{@bom_file_path}")
      else
        puts "#{@gems.size} gems were written to BOM located at #{@bom_file_path}"
      end
    rescue StandardError => e
      @logger.error("Unable to write BOM to #{@bom_file_path}. #{e.message}: #{e.backtrace.join('\n')}")
      abort
    end
  end
  private
  def self.setup(path)
    @options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: cyclonedx-ruby [options]'

      opts.on('-v', '--[no-]verbose', 'Run verbosely') do |v|
        @options[:verbose] = v
      end
      opts.on('-p', '--path path', '(Required) Path to Ruby project directory') do |path|
        @options[:path] = path
      end
      opts.on('-o', '--output bom_file_path', '(Optional) Path to output the bom.xml file to') do |bom_file_path|
        @options[:bom_file_path] = bom_file_path
      end
      opts.on('-f', '--format bom_output_format', '(Optional) Output format for bom. Currently support xml (default) and json.') do |bom_output_format|
        @options[:bom_output_format] = bom_output_format
      end
      opts.on_tail('-h', '--help', 'Show help message') do
        puts opts
        exit
      end
    end.parse!

    @logger = Logger.new($stdout)
    @logger.level = if @options[:verbose]
                      Logger::INFO
                    else
                      Logger::ERROR
                    end

    @gems = []
    licenses_file = File.read "#{__dir__}/licenses.json"
    @licenses_list = JSON.parse(licenses_file)

    if @options[:path].nil?
      @logger.error('missing path to project directory')
      abort
    end

    unless File.directory?(@options[:path])
      @logger.error("path provided is not a valid directory. path provided was: #{@options[:path]}")
      abort
    end

    begin
      @logger.info("Changing directory to Ruby project directory located at #{@options[:path]}")
      Dir.chdir @options[:path]
    rescue StandardError => e
      @logger.error("Unable to change directory to Ruby project directory located at #{@options[:path]}. #{e.message}: #{e.backtrace.join('\n')}")
      abort
    end

    if @options[:bom_output_format].nil?
      @bom_output_format = 'xml'
    elsif SUPPORTED_BOM_FORMATS.include?(@options[:bom_output_format])
      @bom_output_format = @options[:bom_output_format]
    else
      @logger.error("Unrecognized cyclonedx bom output format provided. Please choose one of #{SUPPORTED_BOM_FORMATS}")
      abort
    end

    @bom_file_path = if @options[:bom_file_path].nil?
                       "./bom.#{@bom_output_format}"
                     else
                       @options[:bom_file_path]
                     end

    @logger.info("BOM will be written to #{@bom_file_path}")

    begin
      gemfile_path = "#{@options[:path]}/Gemfile.lock"
      @logger.info("Parsing specs from #{gemfile_path}...")
      gemfile_contents = File.read(gemfile_path)
      @specs = Bundler::LockfileParser.new(gemfile_contents).specs
      @logger.info('Specs successfully parsed!')
    rescue StandardError => e
      @logger.error("Unable to parse specs from #{gemfile_path}. #{e.message}: #{e.backtrace.join('\n')}")
      abort
    end
  end

  def self.specs_list
    count = 0
    @specs.each do |dependency|
      object = OpenStruct.new
      object.name = dependency.name
      object.version = dependency.version
      object.purl = purl(object.name, object.version)
      gem = get_gem(object.name, object.version)
      next if gem.nil?

      if gem['licenses']&.length&.positive?
        if @licenses_list.include? gem['licenses'].first
          object.license_id = gem['licenses'].first
        else
          object.license_name = gem['licenses'].first
        end
      end

      object.authors = gem['authors']
      object.created_at = gem['created_at']
      object.description = gem['summary']
      object.hash = gem['sha']
      @gems.push(object)
      count += 1
      @logger.info("#{object.name}:#{object.version} gem added")
    end
  end
end

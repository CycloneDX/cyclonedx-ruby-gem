# frozen_string_literal: true

module Cyclonedx
  class BomBuilder
    SUPPORTED_BOM_FORMATS = %w[xml json]
    SUPPORTED_SPEC_VERSIONS = %w[1.1 1.2 1.3 1.4 1.5 1.6 1.7]

    extend Cyclonedx::BomHelpers

    def self.build(path)
      original_working_directory = Dir.pwd
      setup(path)

      # If asked to validate an existing file, do not generate a new one
      if @options[:validate] && @options[:validate_file]
        content = begin
          File.read(@options[:validate_file])
        rescue StandardError => e
          @logger.error("Unable to read file for validation: #{@options[:validate_file]}. #{e.message}")
          exit(1)
        end
        # Use explicitly provided format if set, otherwise infer from file extension
        format = @options[:bom_output_format] || infer_format_from_path(@options[:validate_file])
        success, message = validate_bom_content(content, format, @spec_version)
        unless success
          @logger.error(message)
          exit(1)
        end
        puts "Validation succeeded for #{@options[:validate_file]} (spec #{@spec_version})" unless @options[:verbose]
        return
      end

      specs_list
      bom = build_bom(@gems, @bom_output_format, @spec_version)

      begin
        @logger.info("Changing directory to the original working directory located at #{original_working_directory}")
        Dir.chdir original_working_directory
      rescue StandardError => e
        @logger.error("Unable to change to the original working directory located at #{original_working_directory}. #{e.message}: #{Array(e.backtrace).join("\n")}")
        abort
      end

      bom_directory = File.dirname(@bom_file_path)
      begin
        FileUtils.mkdir_p(bom_directory) unless File.directory?(bom_directory)
      rescue StandardError => e
        @logger.error("Unable to create the directory to hold the BOM output at #{bom_directory}. #{e.message}: #{Array(e.backtrace).join("\n")}")
        abort
      end

      begin
        @logger.info("Writing BOM to #{@bom_file_path}...")
        File.write(@bom_file_path, bom)

        if @options[:verbose]
          @logger.info("#{@gems.size} gems were written to BOM located at #{@bom_file_path}")
        else
          puts "#{@gems.size} gems were written to BOM located at #{@bom_file_path}"
        end
      rescue StandardError => e
        @logger.error("Unable to write BOM to #{@bom_file_path}. #{e.message}: #{Array(e.backtrace).join("\n")}")
        abort
      end

      if @options[:validate]
        success, message = validate_bom_content(bom, @bom_output_format, @spec_version)
        unless success
          @logger.error(message)
          exit(1)
        end
        @logger.info("BOM validation succeeded for spec #{@spec_version}") if @options[:verbose]
      end
    end

    # Infer format from file extension when not explicitly provided
    def self.infer_format_from_path(path)
      File.extname(path).downcase == '.json' ? 'json' : 'xml'
    end

    private

    def self.setup(path)
      @options = {}
      OptionParser.new do |opts|
        opts.banner = 'Usage: cyclonedx-ruby [options]'

        opts.on('-v', '--[no-]verbose', 'Run verbosely') do |v|
          @options[:verbose] = v
        end
        opts.on('-p', '--path path', '(Required) Path to Ruby project directory') do |proj_path_opt|
          @options[:path] = proj_path_opt
        end
        opts.on('-o', '--output bom_file_path', '(Optional) Path to output the bom.xml file to') do |bom_file_path|
          @options[:bom_file_path] = bom_file_path
        end
        opts.on('-f', '--format bom_output_format', '(Optional) Output format for bom. Currently support xml (default) and json.') do |bom_output_format|
          @options[:bom_output_format] = bom_output_format
        end
        opts.on('-s', '--spec-version version', '(Optional) CycloneDX spec version to target (default: 1.7). Supported: 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7') do |spec_version|
          @options[:spec_version] = spec_version
        end
        opts.on('--validate', 'Validate the produced BOM against the selected CycloneDX schema') do
          @options[:validate] = true
        end
        opts.on('--validate-file PATH', 'Validate an existing BOM file instead of generating one') do |path|
          @options[:validate_file] = path
        end
        opts.on_tail('-h', '--help', 'Show help message') do
          puts opts
          exit
        end
      end.parse!

      # Allow passing the path as a positional arg via exe wrapper
      @options[:path] ||= path

      @logger = Logger.new($stdout)
      @logger.level = if @options[:verbose]
                        Logger::INFO
                      else
                        Logger::ERROR
                      end

      @gems = []
      # Adjusted to point to lib/licenses.json relative to this file's directory (lib/cyclonedx)
      licenses_path = File.expand_path('../licenses.json', __dir__)
      licenses_file = File.read(licenses_path)
      @licenses_list = JSON.parse(licenses_file)

      # If only validating a file, project path is optional; otherwise require
      if @options[:validate_file].nil? || !@options[:validate]
        if @options[:path].nil?
          @logger.error('missing path to project directory')
          abort
        end

        unless File.directory?(@options[:path])
          @logger.error("path provided is not a valid directory. path provided was: #{@options[:path]}")
          abort
        end
      end

      # Normalize to an absolute project path to avoid relative path issues later
      @project_path = File.expand_path(@options[:path]) if @options[:path]
      @provided_path = @options[:path]

      if @project_path
        begin
          @logger.info("Changing directory to Ruby project directory located at #{@provided_path}")
          Dir.chdir @project_path
        rescue StandardError => e
          @logger.error("Unable to change directory to Ruby project directory located at #{@provided_path}. #{e.message}: #{Array(e.backtrace).join("\n")}")
          abort
        end
      end

      if @options[:bom_output_format].nil?
        @bom_output_format = 'xml'
      elsif SUPPORTED_BOM_FORMATS.include?(@options[:bom_output_format])
        @bom_output_format = @options[:bom_output_format]
      else
        @logger.error("Unrecognized cyclonedx bom output format provided. Please choose one of #{SUPPORTED_BOM_FORMATS}")
        abort
      end

      # Spec version selection
      requested_spec = @options[:spec_version] || '1.7'
      if SUPPORTED_SPEC_VERSIONS.include?(requested_spec)
        @spec_version = requested_spec
      else
        @logger.error("Unrecognized CycloneDX spec version '#{requested_spec}'. Please choose one of #{SUPPORTED_SPEC_VERSIONS}")
        abort
      end

      @bom_file_path = if @options[:bom_file_path].nil?
                         "./bom.#{@bom_output_format}"
                       else
                         @options[:bom_file_path]
                       end

      @logger.info("BOM will be written to #{@bom_file_path}") if @project_path

      if @project_path
        begin
          # Use absolute path so it's correct regardless of current working directory
          gemfile_path = File.join(@project_path, 'Gemfile.lock')
          # Compute display path for logs: './Gemfile.lock' when provided path is '.', else '<provided>/Gemfile.lock'
          display_gemfile_path = (@provided_path == '.' ? './Gemfile.lock' : File.join(@provided_path, 'Gemfile.lock'))
          @logger.info("Parsing specs from #{display_gemfile_path}...")
          gemfile_contents = File.read(gemfile_path)
          @specs = Bundler::LockfileParser.new(gemfile_contents).specs
          @logger.info('Specs successfully parsed!')
        rescue StandardError => e
          @logger.error("Unable to parse specs from #{gemfile_path}. #{e.message}: #{Array(e.backtrace).join("\n")}")
          abort
        end
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

        object.author = gem['authors']
        object.description = gem['summary']
        object.hash = gem['sha']
        @gems.push(object)
        count += 1
        @logger.info("#{object.name}:#{object.version} gem added")
      end
    end
  end
end

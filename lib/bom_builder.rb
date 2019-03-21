require "bundler"
require "nokogiri"
require "ostruct"
require "json"
require "rest_client"
require "optparse"
require "logger"
require_relative "bom_helpers"

class Bombuilder
  def self.build(path)

    setup(path)
    specs_list
    bom = build_bom(@gems)
    File.open("bom.xml", "w") {|file| file.write(bom)}
  end
  private
  def self.setup(path)
    @options = {}
    OptionParser.new do |opts|
      opts.banner = "Usage: cyclonedx-ruby [options]"
    
      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        @options[:verbose] = v
      end
      opts.on("-p", "--path path", "Path to ROR project directory") do |path|
        @options[:path] = path
      end 
      opts.on_tail("-h", "--help", "Show help message") do
        puts opts
        exit
      end
    end.parse!

    @logger = Logger.new(STDOUT)
    if @options[:verbose]
      @logger.level = Logger::INFO
    else
      @logger.level = Logger::ERROR
    end

    @gems = []
    licenses_file = File.read "lib/licenses.json"
    @licenses_list = JSON.parse(licenses_file)

    if @options[:path].nil?
      @logger.error("missing path to project directory")
      abort
    end

    begin
      Dir.chdir @options[:path]
      gemfile = File.read("Gemfile.lock")
      @specs = Bundler::LockfileParser.new(gemfile).specs
    rescue 
      @logger.error("Input argument should refer to a valid Ruby on Rails project folder")
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
      
      if gem["licenses"] and gem["licenses"].length > 0
        if @licenses_list.include? gem["licenses"].first
          object.license_id = gem["licenses"].first
        else
          object.license_name = gem["licenses"].first
        end
      end

      object.author = gem["authors"]
      object.description = gem["summary"] 
      object.hash = gem["sha"]
      @gems.push(object)
      count += 1
      @logger.info("#{object.name}:#{object.version} gem added")
    end
    if option[:verbose]
      @logger.info("#{count} gems were added to #{@options[:path]}/bom.xml")
    else
      puts "#{count} gems were added to #{@options[:path]}/bom.xml"
    end
  end 
end

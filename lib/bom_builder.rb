require "bundler"
require "nokogiri"
require "ostruct"
require "json"
require "rest_client"
require "optparse"
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
    options = {}
    OptionParser.new do |opts|
      opts.banner = "Usage: example.rb [options]"
    
      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        options[:verbose] = v
      end
      opts.on("-p", "--path path", "Path") do |path|
        options[:path] = path
      end 
    end.parse!
    puts options

    @gems = []
    licenses_file = File.read "lib/licenses.json"
    @licenses_list = JSON.parse(licenses_file)
    abort("missing path to project directory") if path.nil?
    
    begin
      Dir.chdir options[:path]
      gemfile = File.read("Gemfile.lock")
      @specs = Bundler::LockfileParser.new(gemfile).specs
    rescue 
      abort "Input argument should refer to a valid Ruby on Rails project folder"
    end
  end
  
  def self.specs_list
    count = 0
    @specs.each do |dependency|
      puts @licenses
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
      puts "#{object.name}:#{object.version} gem added"
    end
    puts "#{count} gems were added"
  end 
end

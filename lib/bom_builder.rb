require "bundler"
require "nokogiri"
require "ostruct"
require "json"
require "rest_client"
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
        @gems = []

        licenses_file = File.read "lib/licenses.json"
        @licenses_list = JSON.parse(licenses_file)

        abort("missing path to project directory") if path.nil?
        
        begin
            Dir.chdir path
            gemfile = File.read("Gemfile.lock")
            @specs = Bundler::LockfileParser.new(gemfile).specs
        rescue 
            abort "Input argument should refer to a valid Ruby on Rails project folder"
        end

    end
    def self.specs_list
        @specs.each do |dependency|
            puts @licenses
            object = OpenStruct.new
            object.name = dependency.name 
            object.version = dependency.version 
            object.purl = purl(object.name, object.version)
            gem = get_gem(object.name, object.version)
            next if gem.nil?
            if gem["licenses"] and @licenses_list.include? gem["licenses"].first
                object.license = gem["licenses"].first
            end
            object.author = gem["authors"]
            object.description = gem["summary"] 
            object.hash = gem["sha"]
            @gems.push(object)
            puts "#{object.name}:#{object.version} gem added"
        end
    end 
end

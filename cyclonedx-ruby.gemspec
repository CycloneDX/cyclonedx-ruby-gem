#test
Gem::Specification.new do |s|
    s.name        = "cyclonedx-ruby"
    s.version     = "1.0.0"
    s.date        = "2019-02-25"
    s.summary     = "bom file builder"
    s.description = "Create bill of materials file"
    s.authors     = ["Joseph Kobti"]
    s.email       = "josephkobti@outlook.com"
    s.files       = ["lib/bom_builder.rb", "lib/bom_helpers.rb", "lib/licenses.json"]
    s.homepage    = "http://rubygems.org/gems/bom_builder" 
    s.license       = "todo"
    s.executables << "cyclonedx-ruby"
  end
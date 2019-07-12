Gem::Specification.new do |s|
  s.name        = "cyclonedx-ruby"
  s.version     = "1.0.1"
  s.date        = "2019-03-21"
  s.summary     = "bom file builder"
  s.description = "CycloneDX software bill-of-material (SBoM) generation utility"
  s.authors     = ["Joseph Kobti"]
  s.email       = "josephkobti@outlook.com"
  s.files       = ["lib/bom_builder.rb", "lib/bom_helpers.rb", "lib/licenses.json"]
  s.homepage    = "http://rubygems.org/gems/cyclonedx-ruby" 
  s.license       = "Apache-2.0"
  s.executables << "cyclonedx-ruby"
end
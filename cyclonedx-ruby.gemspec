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
  s.add_runtime_dependency 'nokogiri', '~> 1.10', '>= 1.10.3'
  s.add_runtime_dependency 'ostruct', '~> 0.1.0'
  s.add_runtime_dependency 'json', '~> 2.2'
  s.add_runtime_dependency 'rest-client', '~> 2.0', '>= 2.0.2'
  s.add_runtime_dependency 'logger', '~> 1.3'
end
Gem::Specification.new do |spec|
  spec.name        = "cyclonedx-ruby"
  spec.version     = "1.1.0"
  spec.date        = "2019-07-12"
  spec.summary     = "CycloneDX software bill-of-material (SBoM) generation utility"
  spec.description = "CycloneDX is a lightweight software bill-of-material (SBOM) specification designed for use in application security contexts and supply chain component analysis. This Gem generates CycloneDX BOMs from Ruby projects."
  spec.authors     = ["Joseph Kobti", "Steve Springett"]
  spec.email       = "josephkobti@outlook.com"
  spec.files       = ["lib/bom_builder.rb", "lib/bom_helpers.rb", "lib/licenses.json"]
  spec.homepage    = "https://github.com/CycloneDX/cyclonedx-ruby-gem"
  spec.license     = "Apache-2.0"
  spec.executables << "cyclonedx-ruby"
  spec.add_dependency('json', '~> 2.2')
  spec.add_dependency('nokogiri', '~> 1.8')
  spec.add_dependency('ostruct', '~> 0.1')
  spec.add_dependency('rest-client', '~> 2.0')
  spec.add_development_dependency 'rake', '~> 12'
  spec.add_development_dependency 'rspec', '~> 3.7'
end
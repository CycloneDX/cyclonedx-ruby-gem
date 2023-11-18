# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name        = 'cyclonedx-ruby'
  spec.version     = '1.2.0'
  spec.date        = '2023-07-14'
  spec.summary     = 'CycloneDX software bill-of-material (SBoM) generation utility'
  spec.description = 'CycloneDX is a lightweight software bill-of-material (SBOM) specification designed for use in application security contexts and supply chain component analysis. This Gem generates CycloneDX BOMs from Ruby projects.'
  spec.authors     = ['Joseph Kobti', 'Steve Springett']
  spec.email       = 'josephkobti@outlook.com'
  spec.homepage    = 'https://github.com/CycloneDX/cyclonedx-ruby-gem'
  spec.license     = 'Apache-2.0'

  spec.required_ruby_version = '>= 2.7.0'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency('json', '~> 2.6')
  spec.add_dependency('nokogiri', '~> 1.15')
  spec.add_dependency('ostruct', '~> 0.5.5')
  spec.add_dependency('rest-client', '~> 2.0')
  spec.add_dependency('activesupport', '~> 7.0')
  spec.add_development_dependency 'rake', '~> 13'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'cucumber', '~> 9.1'
  spec.add_development_dependency 'aruba', '~> 2.1'
  spec.add_development_dependency 'simplecov', '~> 0.22.0'
  spec.add_development_dependency 'rubocop',  '~> 1.54'
end

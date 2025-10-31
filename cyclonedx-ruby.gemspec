# frozen_string_literal: true

require_relative "lib/cyclonedx/ruby/version"

Gem::Specification.new do |spec|
  spec.name = 'cyclonedx-ruby'
  spec.version = Cyclonedx::Ruby::VERSION
  spec.authors = ['Joseph Kobti', 'Steve Springett']
  spec.email = ['josephkobti@outlook.com']

  spec.summary     = 'CycloneDX software bill-of-material (SBoM) generation utility'
  spec.description = 'CycloneDX is a lightweight software bill-of-material (SBOM) specification designed for use in application security contexts and supply chain component analysis. This Gem generates CycloneDX BOMs from Ruby projects.'
  spec.homepage    = 'https://github.com/CycloneDX/cyclonedx-ruby-gem'
  spec.license     = 'Apache-2.0'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata["homepage_uri"] = "https://github.com/CycloneDX/cyclonedx-ruby-gem?tab=readme-ov-file#readme"
  spec.metadata["source_code_uri"] = "https://github.com/CycloneDX/cyclonedx-ruby-gem/tree/v#{spec.version}"
  spec.metadata["changelog_uri"] = "https://github.com/CycloneDX/cyclonedx-ruby-gem/blob/v#{spec.version}/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/CycloneDX/cyclonedx-ruby-gem/issues"
  spec.metadata["funding_uri"] = "https://owasp.org/donate/?reponame=www-project-cyclonedx&title=OWASP+CycloneDX"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files are part of the released package.
  spec.files = Dir[
    # Code / tasks / data (NOTE: exe/ is specified via spec.bindir and spec.executables below)
    "lib/**/*.rb",
    "lib/licenses.json",
    # Signatures
    "sig/**/*.rbs"
  ]

  # Automatically included with gem package, no need to list again in files.
  spec.extra_rdoc_files = Dir[
    # Files (alphabetical)
    "CHANGELOG.md",
    "LICENSE.txt",
    "NOTICE",
    "README.md"
  ]
  spec.rdoc_options += [
    "--title",
    "#{spec.name} - #{spec.summary}",
    "--main",
    "README.md",
    "--exclude",
    "^sig/",
    "--line-numbers",
    "--inline-source",
    "--quiet"
  ]
  spec.require_paths = ['lib']
  spec.bindir = "exe"
  # Listed files are the relative paths from bindir above.
  spec.executables = ['cyclonedx-ruby']

  spec.add_dependency('json', '~> 2.6')
  spec.add_dependency('nokogiri', '~> 1.15')
  spec.add_dependency('ostruct', '~> 0.5.5')
  spec.add_dependency('rest-client', '~> 2.0')
  spec.add_dependency('activesupport', '~> 7.0')
  spec.add_development_dependency 'rake', '~> 13'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'cucumber', '~> 10.0'
  spec.add_development_dependency 'aruba', '~> 2.2'
  spec.add_development_dependency 'simplecov', '~> 0.22.0'
  spec.add_development_dependency 'rubocop',  '~> 1.54'
  spec.add_development_dependency 'stone_checksums',  '~> 1.0', '>= 1.0.3'
end

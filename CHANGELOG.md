# Changelog

[![SemVer 2.0.0][📌semver-img]][📌semver] [![Keep-A-Changelog 1.0.0][📗keep-changelog-img]][📗keep-changelog]

All notable changes to this project after v1.1.0 will be documented in this file.

The format is based on [Keep a Changelog][📗keep-changelog],
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html),
and [yes][📌major-versions-not-sacred], platform and engine support are part of the [public API][📌semver-breaking].
Please file a bug if you notice a violation of semantic versioning.

[📌semver]: https://semver.org/spec/v2.0.0.html
[📌semver-img]: https://img.shields.io/badge/semver-2.0.0-FFDD67.svg?style=flat
[📌semver-breaking]: https://github.com/semver/semver/issues/716#issuecomment-869336139
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html
[📗keep-changelog]: https://keepachangelog.com/en/1.0.0/
[📗keep-changelog-img]: https://img.shields.io/badge/keep--a--changelog-1.0.0-FFDD67.svg?style=flat

## [Unreleased]

### Added

- `CONTRIBUTING.md` file to help people find their way to contributing
- `CHANGELOG.md` file to document notable changes in keep-a-changelog format
- `Cyclonedx::BomHelpers` module to house helper methods, replacing global methods
- `Cyclonedx::BomBuilder` class, replacing `Bombuilder` (note the capitalization change)
- `Cyclonedx::BomComponent` class, replacing `BomComponent`
- `Cyclonedx::Ruby::Version::VERSION` constant to hold the version number (also available as `Cyclonedx::VERSION`)
- `Cyclonedx::Ruby::Deprecation` module to help manage deprecations
- dev dependency: `stone_checksums`
  - For SHA-256 and SHA-512 checksum generation for each release.
- signed gem releases
  - See: [RubyGems Security Guide][🔒️rubygems-security-guide]
- CI matrix testing on Ruby 3.3, 3.4

[🔒️rubygems-security-guide]: https://guides.rubygems.org/security/#building-gems

### Changed

- Updated gemspec metadata for clarity and consistency
- Modernized Rakefile, dotfiles, and test setup
- `LICENSE` => `LICENSE.txt` to simplify parsing consistency on various platforms and tools
- `cucumber` v8 => v10
- `aruba` v2.1 => v2.2

### Deprecated

- `BomComponent` => `Cyclonedx::BomComponent`
- `Bombuilder` => `Cyclonedx::BomBuilder` (note the capitalization change)
- `Object.purl` => `Cyclonedx::BomHelpers.purl`
- `Object.random_urn_uuid` => `Cyclonedx::BomHelpers.random_urn_uuid`
- `Object.build_bom` => `Cyclonedx::BomHelpers.build_bom`
- `Object.build_json_bom` => `Cyclonedx::BomHelpers.build_json_bom`
- `Object.build_bom_xml` => `Cyclonedx::BomHelpers.build_bom_xml`
- `Object.get_gem` => `Cyclonedx::BomHelpers.get_gem`

### Removed

### Fixed

- `Nokogiri::XML::Builder` context relies on `method_missing`
  - Globally defined `Object#purl` conflicted with `<purl>`.
  - Moved to `Cyclonedx::BomHelpers.purl` to avoid conflict in v2.0.0 (along with all other global methods)
  - Fixed existing usage via the built-in Nokogiri workaround of adding an underscore `purl_`
  - The XML tag is unchanged as `<purl>`

### Security

## [1.1.0] - 2019-07-13

- TAG: [v1.1.0][1.1.0t]

### Added

- Initial release

[Unreleased]: https://gitlab.com/CycloneDX/cyclonedx-ruby-gem/-/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/CycloneDX/cyclonedx-ruby-gem/compare/eecfebe3cb0ce961fef8e424162ac94298f02a9f...v1.1.0
[1.1.0t]: https://github.com/CycloneDX/cyclonedx-ruby-gem/releases/tag/v1.1.0

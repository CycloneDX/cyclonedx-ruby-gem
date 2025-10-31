[![Build Status](https://github.com/CycloneDX/cyclonedx-ruby-gem/workflows/Ruby%20CI/badge.svg)](https://github.com/CycloneDX/cyclonedx-ruby-gem/actions?workflow=Ruby+CI)
[![Gem Version](https://badge.fury.io/rb/cyclonedx-ruby.svg)](https://badge.fury.io/rb/cyclonedx-ruby)
[![License](https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg)][License]
[![Website](https://img.shields.io/badge/https://-cyclonedx.org-blue.svg)](https://cyclonedx.org/)
[![Slack Invite](https://img.shields.io/badge/Slack-Join-blue?logo=slack&labelColor=393939)](https://cyclonedx.org/slack/invite)
[![Group Discussion](https://img.shields.io/badge/discussion-groups.io-blue.svg)](https://groups.io/g/CycloneDX)
[![Twitter](https://img.shields.io/twitter/url/http/shields.io.svg?style=social&label=Follow)](https://twitter.com/CycloneDX_Spec)


# CycloneDX Ruby Gem

The CycloneDX Ruby Gem creates a valid CycloneDX Software Bill of Materials (SBOM) from all project dependencies. CycloneDX is a lightweight SBOM specification that is easily created, human-readable, and simple to parse. 

#### Installing from RubyGems

```bash
gem install cyclonedx-ruby 
```

#### Building and Installing From Source

```bash
gem build cyclonedx-ruby.gemspec
gem install cyclonedx-ruby-x.x.x.gem 
```

#### Usage
cyclonedx-ruby [options]

    `-v, --[no-]verbose` Run verbosely
    `-p, --path path` Path to Ruby project directory
    `-f, --format` Bom output format
    `-h, --help` Show help message

**Output:** bom.xml or bom.json file in project directory

#### Example
```bash
cyclonedx-ruby -p /path/to/ruby/project
```


Copyright & License
-------------------

CycloneDX Ruby Gem is Copyright (c) OWASP Foundation. All Rights Reserved.

Permission to modify and redistribute is granted under the terms of the Apache 2.0 license. See the [LICENSE] file for the full license.

[License]: https://github.com/CycloneDX/cyclonedx-ruby-gem/blob/master/LICENSE


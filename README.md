# CycloneDX Ruby Gem

[![Gem Version](https://img.shields.io/gem/v/cyclonedx-ruby?logo=rubygems&logoColor=white)](https://bestgems.org/gems/cyclonedx-ruby)
[![CT status](https://img.shields.io/github/actions/workflow/status/CycloneDX/cyclonedx-ruby-gem/ruby.yml?branch=master&logo=GitHub&logoColor=white)](https://github.com/CycloneDX/cyclonedx-ruby-gem/actions/workflows/ruby.yml?query=branch%3Amaster)
[![License](https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg)][License]  
[![Website](https://img.shields.io/badge/https://-cyclonedx.org-blue.svg)](https://cyclonedx.org/)
[![Slack Invite](https://img.shields.io/badge/Slack-Join-blue?logo=slack&labelColor=393939)](https://cyclonedx.org/slack/invite)
[![Group Discussion](https://img.shields.io/badge/discussion-groups.io-blue.svg)](https://groups.io/g/CycloneDX)
[![Twitter](https://img.shields.io/twitter/url/http/shields.io.svg?style=social&label=Follow)](https://twitter.com/CycloneDX_Spec)

----

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
    `-o, --output bom_file_path` Path to output the bom file
    `-f, --format bom_output_format` Output format for bom. Supported: xml (default), json
    `-s, --spec-version version` CycloneDX spec version to target (default: 1.7). Supported: 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7
    `--include-metadata` Include metadata.tools identifying cyclonedx-ruby as the producer
    `--enrich-components` Include bom-ref and publisher fields on components (uses purl and first author)
    `--gem-server URL` Gem server URL to fetch gem metadata (default: https://gem.coop)
    `-h, --help` Show help message

**Output:** bom.xml or bom.json file in project directory

- By default, outputs conform to CycloneDX spec version 1.7.
- To generate an older spec version, use `--spec-version`.
- To embed metadata about this tool (vendor/name/version) into the BOM, pass `--include-metadata` (supported for spec >= 1.2).
- To enrich components with bom-ref and publisher fields, pass `--enrich-components`.
- To specify a custom gem server for fetching gem metadata, use `--gem-server URL` (default: https://gem.coop).

#### Examples
```bash
# Default (XML, CycloneDX 1.7)
cyclonedx-ruby -p /path/to/ruby/project

# JSON at CycloneDX 1.7
cyclonedx-ruby -p /path/to/ruby/project -f json

# XML at CycloneDX 1.3
cyclonedx-ruby -p /path/to/ruby/project -s 1.3

# JSON at CycloneDX 1.2 to a custom path
cyclonedx-ruby -p /path/to/ruby/project -f json -s 1.2 -o bom/out.json

# Include producer metadata and validate
cyclonedx-ruby -p /path/to/ruby/project --include-metadata

# Enrich components with bom-ref and publisher
cyclonedx-ruby -p /path/to/ruby/project --enrich-components

# Use a custom gem server
cyclonedx-ruby -p /path/to/ruby/project --gem-server https://custom.gem.server
```


Copyright & License
-------------------

CycloneDX Ruby Gem is Copyright (c) OWASP Foundation. All Rights Reserved.

Permission to modify and redistribute is granted under the terms of the Apache 2.0 license. See the [LICENSE] file for the full license.

[License]: https://github.com/CycloneDX/cyclonedx-ruby-gem/blob/master/LICENSE.txt

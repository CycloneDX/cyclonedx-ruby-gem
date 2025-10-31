Feature: Command Help

The `cyclonedx-ruby` needs to provide help output so that people know the
parameters that they can specify.

Scenario: Generate help on demand
  Given I run `cyclonedx-ruby --help`
  Then the output should contain:
  """
  Usage: cyclonedx-ruby [options]
      -v, --[no-]verbose               Run verbosely
      -p, --path path                  (Required) Path to Ruby project directory
      -o, --output bom_file_path       (Optional) Path to output the bom.xml file to
      -f, --format bom_output_format   (Optional) Output format for bom. Currently support xml (default) and json.
      -s, --spec-version version       (Optional) CycloneDX spec version to target (default: 1.7). Supported: 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7
          --validate                   Validate the produced BOM against the selected CycloneDX schema
          --validate-file PATH         Validate an existing BOM file instead of generating one
          --include-metadata           Include metadata.tools identifying cyclonedx-ruby as the producer
          --enrich-components          Include bom-ref and publisher fields on components (uses purl and first author)
      -h, --help                       Show help message
  """

Feature: Include metadata.tools in BOM

  Scenario: JSON output includes metadata.tools when flag is set
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format json --include-metadata`
    Then a file named "bom.json" should exist
    And the output should contain:
    """
    5 gems were written to BOM located at ./bom.json
    """
    And the file "bom.json" should contain:
    """
    "metadata": {
    """
    And the file "bom.json" should contain:
    """
    "tools": [
    """
    And the file "bom.json" should contain:
    """
    "vendor": "CycloneDX"
    """
    And the file "bom.json" should contain:
    """
    "name": "cyclonedx-ruby"
    """

  Scenario: JSON metadata BOM validates against schema
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format json --include-metadata --validate`
    Then the output should contain:
    """
    5 gems were written to BOM located at ./bom.json
    """
    And a file named "bom.json" should exist

  Scenario: XML output includes metadata.tools when flag is set
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format xml --include-metadata`
    Then a file named "bom.xml" should exist
    And the output should contain:
    """
    5 gems were written to BOM located at ./bom.xml
    """
    And the file "bom.xml" should contain:
    """
    <metadata>
    """
    And the file "bom.xml" should contain:
    """
    <tools>
    """
    And the file "bom.xml" should contain:
    """
    <tool>
    """
    And the file "bom.xml" should contain:
    """
    <vendor>CycloneDX</vendor>
    """
    And the file "bom.xml" should contain:
    """
    <name>cyclonedx-ruby</name>
    """

  Scenario: XML metadata BOM validates against schema
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format xml --include-metadata --validate`
    Then the output should contain:
    """
    5 gems were written to BOM located at ./bom.xml
    """
    And a file named "bom.xml" should exist

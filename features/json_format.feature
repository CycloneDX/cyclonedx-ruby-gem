Feature: Creating BOM using Json format

  Scenario: Using default output path
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format json`
    Then the output should contain:
    """
    5 gems were written to BOM located at ./bom.json
    """
    And a file named "bom.json" should exist
    And the generated XML Json file "bom.json" matches "bom.json.expected"

  Scenario: Specifying the output path
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format json --output bom/simple.bom.json`
    Then the output should contain:
    """
    5 gems were written to BOM located at bom/simple.bom.json
    """
    And a file named "bom/simple.bom.json" should exist
    And the generated XML Json file "bom/simple.bom.json" matches "bom.json.expected"

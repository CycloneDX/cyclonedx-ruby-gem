Feature: Creating BOM using Json format

  Scenario: Running against simple fixture
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format json`
    Then the output should contain:
    """
    5 gems were written to BOM located at ./bom.json
    """
    And a file named "bom.json" should exist
    And the generated XML Json file "bom.json" matches "bom.json.expected"

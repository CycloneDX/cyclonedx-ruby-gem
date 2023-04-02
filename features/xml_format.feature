Feature: Creating BOM using XML format

  Scenario: Running against simple fixture
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format xml`
    Then the output should contain:
    """
    5 gems were written to BOM located at ./bom.xml
    """
    And a file named "bom.xml" should exist
    And the generated XML BOM file "bom.xml" matches "bom.xml.expected"

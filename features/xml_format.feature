Feature: Creating BOM using XML format

  Scenario: Using default output path
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format xml`
    Then the output should contain:
    """
    5 gems were written to BOM located at ./bom.xml
    """
    And a file named "bom.xml" should exist
    And the generated XML BOM file "bom.xml" matches "bom.xml.expected"

  Scenario: Specifying the output path
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format xml --output bom/simple.bom.xml`
    Then the output should contain:
    """
    5 gems were written to BOM located at bom/simple.bom.xml
    """
    And a file named "bom/simple.bom.xml" should exist
    And the generated XML BOM file "bom/simple.bom.xml" matches "bom.xml.expected"

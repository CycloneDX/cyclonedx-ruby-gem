Feature: Validate generated BOM against CycloneDX schema

  Scenario: Validate XML BOM succeeds
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format xml --validate`
    Then the output should contain:
    """
    5 gems were written to BOM located at ./bom.xml
    """
    And a file named "bom.xml" should exist

  Scenario: Validate JSON BOM succeeds
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format json --validate`
    Then the output should contain:
    """
    5 gems were written to BOM located at ./bom.json
    """
    And a file named "bom.json" should exist

  Scenario: Validate fails for invalid XML BOM
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format xml`
    Then a file named "bom.xml" should exist
    When I run `sh -lc "sed -i 's|http://cyclonedx.org/schema/bom/1.7|http://cyclonedx.org/schema/bom/9.9|' bom.xml"`
    And I run `cyclonedx-ruby --validate --validate-file bom.xml --spec-version 1.7`
    Then the exit status should be 1

  Scenario: Validate existing XML BOM succeeds
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format xml`
    Then a file named "bom.xml" should exist
    When I run `cyclonedx-ruby --validate --validate-file bom.xml --spec-version 1.7`
    Then the output should contain:
    """
    Validation succeeded for bom.xml (spec 1.7)
    """

  Scenario: Validate existing JSON BOM succeeds
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format json`
    Then a file named "bom.json" should exist
    When I run `cyclonedx-ruby --validate --validate-file bom.json --spec-version 1.7`
    Then the output should contain:
    """
    Validation succeeded for bom.json (spec 1.7)
    """

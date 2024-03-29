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

  Scenario: Verbose output
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format xml --verbose`
    Then the output should match:
      """
      I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : Changing directory to Ruby project directory located at \.
      I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : BOM will be written to \./bom\.xml
      I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : Parsing specs from \./Gemfile\.lock\.\.\.
      I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : Specs successfully parsed!
      I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : activesupport:7\.0\.4\.3 gem added
      I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : concurrent-ruby:1\.2\.2 gem added
      I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : i18n:1\.12\.0 gem added
      I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : minitest:5\.18\.0 gem added
      I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : tzinfo:2\.0\.6 gem added
      I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : Changing directory to the original working directory located at .*/tmp/aruba/simple
      I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : Writing BOM to \./bom\.xml\.\.\.
      I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : 5 gems were written to BOM located at \./bom\.xml
      """
    And a file named "bom.xml" should exist
    And the generated XML BOM file "bom.xml" matches "bom.xml.expected"

Feature: Creating BOM using Json format

  Scenario: Using default output path
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format json`
    Then the output should contain:
    """
    5 gems were written to BOM located at ./bom.json
    """
    And a file named "bom.json" should exist
    And the generated Json BOM file "bom.json" matches "bom.json.expected"

  Scenario: Specifying the output path
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format json --output bom/simple.bom.json`
    Then the output should contain:
    """
    5 gems were written to BOM located at bom/simple.bom.json
    """
    And a file named "bom/simple.bom.json" should exist
    And the generated Json BOM file "bom/simple.bom.json" matches "bom.json.expected"

  Scenario: Verbose output
    Given I use a fixture named "simple"
    And I run `cyclonedx-ruby --path . --format json --verbose`
    Then the output should match:
    """
    I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : Changing directory to Ruby project directory located at \.
    I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : BOM will be written to \./bom\.json
    I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : Parsing specs from \./Gemfile\.lock\.\.\.
    I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : Specs successfully parsed!
    I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : activesupport:7\.0\.4\.3 gem added
    I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : concurrent-ruby:1\.2\.2 gem added
    I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : i18n:1\.12\.0 gem added
    I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : minitest:5\.18\.0 gem added
    I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : tzinfo:2\.0\.6 gem added
    I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : Changing directory to the original working directory located at .*/tmp/aruba/simple
    I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : Writing BOM to \./bom\.json\.\.\.
    I, \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d+\]  INFO -- : 5 gems were written to BOM located at \./bom\.json
    """
    And a file named "bom.json" should exist
    And the generated Json BOM file "bom.json" matches "bom.json.expected"

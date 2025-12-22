Feature: Custom Gem Server

The `cyclonedx-ruby` command should allow users to specify a custom gem server
to fetch gem metadata from, instead of using the default gem.coop server.

Scenario: Use default gem server (gem.coop)
  Given I use a fixture named "simple"
  And I run `cyclonedx-ruby --path .`
  Then the output should contain:
  """
  5 gems were written to BOM located at ./bom.xml
  """
  And a file named "bom.xml" should exist
  And the generated XML BOM file "bom.xml" matches "bom.xml.expected"

Scenario: Use custom gem server
  Given I use a fixture named "simple"
  And I run `cyclonedx-ruby --path . --gem-server https://rubygems.org`
  Then the output should contain:
  """
  5 gems were written to BOM located at ./bom.xml
  """
  And a file named "bom.xml" should exist

Scenario: Use custom gem server with trailing slash
  Given I use a fixture named "simple"
  And I run `cyclonedx-ruby --path . --gem-server https://rubygems.org/`
  Then the output should contain:
  """
  5 gems were written to BOM located at ./bom.xml
  """
  And a file named "bom.xml" should exist

Scenario: Help shows gem-server option
  Given I run `cyclonedx-ruby --help`
  Then the output should contain:
  """
  --gem-server URL             Gem server URL to fetch gem metadata (default: https://gem.coop)
  """


# frozen_string_literal: true

require_relative 'cyclonedx/ruby/deprecation'

# Legacy class name kept for compatibility until v2.0.0
Bombuilder = Cyclonedx::BomBuilder

# Legacy class name kept for compatibility until v2.0.0
BomComponent = Cyclonedx::BomComponent

# Legacy global methods included in Object (root namespace) kept for compatibility until v2.0.0
extend Cyclonedx::Ruby::Deprecation

deprecated_alias :instance, :purl, :purl, Cyclonedx::BomHelpers
deprecated_alias :instance, :random_urn_uuid, :random_urn_uuid, Cyclonedx::BomHelpers
deprecated_alias :instance, :build_bom, :build_bom, Cyclonedx::BomHelpers
deprecated_alias :instance, :build_json_bom, :build_json_bom, Cyclonedx::BomHelpers
deprecated_alias :instance, :build_bom_xml, :build_bom_xml, Cyclonedx::BomHelpers
deprecated_alias :instance, :get_gem, :get_gem, Cyclonedx::BomHelpers

# Sanity
raise 'Deprecated methods broken' unless purl('activesupport', '7.0.1') == 'pkg:gem/activesupport@7.0.1'

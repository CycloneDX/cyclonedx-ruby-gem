# frozen_string_literal: true

require 'json'
require 'nokogiri'
require_relative '../../lib/cyclonedx/bom_helpers'
require_relative '../../lib/cyclonedx/ruby/version'

RSpec.describe 'metadata.tools emission' do
  let(:spec_version) { '1.7' }

  it 'adds metadata.tools in JSON when include_metadata is true and spec >= 1.2' do
    json = Cyclonedx::BomHelpers.build_json_bom([], spec_version, include_metadata: true)
    data = JSON.parse(json)
    expect(data['metadata']).to be_a(Hash)
    expect(data['metadata']['tools']).to be_a(Array)
    expect(data['metadata']['tools'].first['vendor']).to eq('CycloneDX')
    expect(data['metadata']['tools'].first['name']).to eq('cyclonedx-ruby')
  end

  it 'does not add metadata when include_metadata is false' do
    json = Cyclonedx::BomHelpers.build_json_bom([], spec_version, include_metadata: false)
    data = JSON.parse(json)
    expect(data).not_to have_key('metadata')
  end

  it 'adds metadata.tools in XML when include_metadata is true and spec >= 1.2' do
    xml = Cyclonedx::BomHelpers.build_bom_xml([], spec_version, include_metadata: true)
    doc = Nokogiri::XML(xml)
    ns = { 'c' => Cyclonedx::BomHelpers.cyclonedx_xml_namespace(spec_version) }
    expect(doc.at_xpath('/c:bom/c:metadata/c:tools/c:tool/c:vendor', ns)&.text).to eq('CycloneDX')
    expect(doc.at_xpath('/c:bom/c:metadata/c:tools/c:tool/c:name', ns)&.text).to eq('cyclonedx-ruby')
  end

  it 'omits metadata in XML when flag is false' do
    xml = Cyclonedx::BomHelpers.build_bom_xml([], spec_version, include_metadata: false)
    doc = Nokogiri::XML(xml)
    ns = { 'c' => Cyclonedx::BomHelpers.cyclonedx_xml_namespace(spec_version) }
    expect(doc.at_xpath('/c:bom/c:metadata', ns)).to be_nil
  end
end


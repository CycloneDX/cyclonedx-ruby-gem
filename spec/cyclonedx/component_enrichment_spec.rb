# frozen_string_literal: true

require 'json'
require 'nokogiri'
require_relative '../../lib/cyclonedx/bom_helpers'

RSpec.describe 'component enrichment' do
  let(:spec_version) { '1.7' }
  let(:gem_obj) do
    # Use OpenStruct-like object by a simple Struct for deterministic methods
    Struct.new(:name, :version, :description, :hash, :purl, :author, :license_id, :license_name)
          .new('sample', '1.0.0', 'desc', 'abc123', 'pkg:gem/sample@1.0.0', 'Alice, Bob', nil, nil)
  end

  it 'adds bom-ref and publisher for JSON when include_enrichment is true' do
    json = Cyclonedx::BomHelpers.build_json_bom([gem_obj], spec_version, include_enrichment: true)
    data = JSON.parse(json)
    comp = data['components'].first
    expect(comp['bom-ref']).to eq('pkg:gem/sample@1.0.0')
    expect(comp['publisher']).to eq('Alice')
  end

  it 'does not add enrichment fields when flag is false' do
    json = Cyclonedx::BomHelpers.build_json_bom([gem_obj], spec_version, include_enrichment: false)
    data = JSON.parse(json)
    comp = data['components'].first
    expect(comp).not_to have_key('bom-ref')
    expect(comp).not_to have_key('publisher')
  end

  it 'adds bom-ref attribute and publisher element for XML when include_enrichment is true' do
    xml = Cyclonedx::BomHelpers.build_bom_xml([gem_obj], spec_version, include_enrichment: true)
    doc = Nokogiri::XML(xml)
    ns = { 'c' => Cyclonedx::BomHelpers.cyclonedx_xml_namespace(spec_version) }
    comp = doc.at_xpath('/c:bom/c:components/c:component', ns)
    expect(comp['bom-ref']).to eq('pkg:gem/sample@1.0.0')
    expect(doc.at_xpath('/c:bom/c:components/c:component/c:publisher', ns)&.text).to eq('Alice')
  end

  it 'omits enrichment fields in XML when flag is false' do
    xml = Cyclonedx::BomHelpers.build_bom_xml([gem_obj], spec_version, include_enrichment: false)
    doc = Nokogiri::XML(xml)
    ns = { 'c' => Cyclonedx::BomHelpers.cyclonedx_xml_namespace(spec_version) }
    comp = doc.at_xpath('/c:bom/c:components/c:component', ns)
    expect(comp['bom-ref']).to be_nil
    expect(doc.at_xpath('/c:bom/c:components/c:component/c:publisher', ns)).to be_nil
  end
end

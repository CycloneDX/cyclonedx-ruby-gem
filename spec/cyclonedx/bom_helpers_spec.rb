# frozen_string_literal: true

RSpec.describe Cyclonedx::BomHelpers do
  context '#purl' do
    context 'when legacy method is called' do
      it 'builds a purl' do
        skip('Deprecated in favor of Cyclonedx::BomHelpers.purl') unless defined?(purl)
        expect(purl('activesupport', '7.0.1')).to eq('pkg:gem/activesupport@7.0.1')
      end
    end

    it 'builds a purl' do
      expect(described_class.purl('activesupport', '7.0.1')).to eq('pkg:gem/activesupport@7.0.1')
    end
  end
end

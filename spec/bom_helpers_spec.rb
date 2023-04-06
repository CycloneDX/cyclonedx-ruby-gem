require 'spec_helper'
require 'bom_helpers'

RSpec.describe 'helper methods' do
  context '#purl' do
    it 'builds a purl' do
      expect(purl('activesupport', '7.0.1')).to eq("pkg:gem/activesupport@7.0.1")
    end
  end
end

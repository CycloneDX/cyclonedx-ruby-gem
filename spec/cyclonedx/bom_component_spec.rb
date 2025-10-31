# frozen_string_literal: true

RSpec.shared_examples 'a valid hash_val result for gem' do
  it { expect(result.count).to eq(1) }
  it { expect(result[0][:type]).to eq('library') }
  it { expect(result[0][:name]).to eq(gem.name) }
  it { expect(result[0][:version]).to eq(gem.version) }
  it { expect(result[0][:description]).to eq(gem.description) }
  it { expect(result[0][:purl]).to eq(gem.purl) }
  it { expect(result[0][:hashes].count).to eq(1) }
  it { expect(result[0][:hashes][0][:alg]).to eq('SHA-256') }
  it { expect(result[0][:hashes][0][:content]).to eq(gem.hash) }
end

RSpec.describe Cyclonedx::BomComponent do
  context '#hash_val' do
    let(:base_gem) do
      OpenStruct.new(
        name: 'Sample',
        version: '1.0.0',
        description: 'Sample description',
        hash: '1f809ab336c437d894df9934a9fc9ffd2ea09b535dfa4e3f75db078531c260c8',
        purl: 'pkg:gem/sample@1.0.0'
      )
    end

    let(:gem) do
      base_gem
    end

    subject(:result) { Cyclonedx::BomComponent.new(gem).hash_val }

    context 'with a gem without a license' do
      include_examples 'a valid hash_val result for gem'
    end

    context 'with a gem that has a license_id' do
      let(:gem) do
        base_gem.tap do |value|
          value.license_id = 'License ID'
        end
      end

      include_examples 'a valid hash_val result for gem'

      it { expect(result[0][:licenses].count).to eq(1) }
      it { expect(result[0][:licenses][0][:license][:id]).to eq(gem.license_id) }
    end

    context 'with a gem that has a license_name' do
      let(:gem) do
        base_gem.tap do |value|
          value.license_name = 'License Name'
        end
      end

      include_examples 'a valid hash_val result for gem'

      it { expect(result[0][:licenses].count).to eq(1) }
      it { expect(result[0][:licenses][0][:license][:name]).to eq(gem.license_name) }
    end
  end
end

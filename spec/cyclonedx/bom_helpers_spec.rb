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

  context '#get_gem' do
    let(:logger) { instance_double(Logger, warn: nil) }
    let(:gem_name) { 'activesupport' }
    let(:gem_version) { '7.0.1' }
    let(:mock_response) do
      [
        { 'number' => '7.0.0', 'licenses' => ['MIT'], 'authors' => 'Rails Core', 'summary' => 'ActiveSupport', 'sha' => 'abc123' },
        { 'number' => '7.0.1', 'licenses' => ['MIT'], 'authors' => 'Rails Core', 'summary' => 'ActiveSupport', 'sha' => 'def456' }
      ]
    end

    before do
      allow(ENV).to receive(:fetch).with('http_proxy', nil).and_return(nil)
      allow(RestClient).to receive(:proxy=)
    end

    context 'with default gem server' do
      it 'uses gem.coop when no gem_server is provided' do
        expect(RestClient::Request).to receive(:execute)
          .with(hash_including(url: "https://gem.coop/api/v1/versions/#{gem_name}.json"))
          .and_return(double(body: mock_response.to_json))

        result = described_class.get_gem(gem_name, gem_version, logger)
        expect(result['number']).to eq('7.0.1')
      end

      it 'uses gem.coop when gem_server is nil' do
        expect(RestClient::Request).to receive(:execute)
          .with(hash_including(url: "https://gem.coop/api/v1/versions/#{gem_name}.json"))
          .and_return(double(body: mock_response.to_json))

        result = described_class.get_gem(gem_name, gem_version, logger, nil)
        expect(result['number']).to eq('7.0.1')
      end
    end

    context 'with custom gem server' do
      it 'uses custom gem server when provided' do
        custom_server = 'https://custom.gem-server.com'
        expect(RestClient::Request).to receive(:execute)
          .with(hash_including(url: "#{custom_server}/api/v1/versions/#{gem_name}.json"))
          .and_return(double(body: mock_response.to_json))

        result = described_class.get_gem(gem_name, gem_version, logger, custom_server)
        expect(result['number']).to eq('7.0.1')
      end

      it 'removes trailing slash from gem server URL' do
        custom_server_with_slash = 'https://custom.gem-server.com/'
        expect(RestClient::Request).to receive(:execute)
          .with(hash_including(url: "https://custom.gem-server.com/api/v1/versions/#{gem_name}.json"))
          .and_return(double(body: mock_response.to_json))

        result = described_class.get_gem(gem_name, gem_version, logger, custom_server_with_slash)
        expect(result['number']).to eq('7.0.1')
      end

      it 'works with rubygems.org as custom server' do
        rubygems_server = 'https://rubygems.org'
        expect(RestClient::Request).to receive(:execute)
          .with(hash_including(url: "#{rubygems_server}/api/v1/versions/#{gem_name}.json"))
          .and_return(double(body: mock_response.to_json))

        result = described_class.get_gem(gem_name, gem_version, logger, rubygems_server)
        expect(result['number']).to eq('7.0.1')
      end
    end

    context 'error handling' do
      it 'returns nil and logs warning when gem cannot be fetched' do
        allow(RestClient::Request).to receive(:execute).and_raise(StandardError.new('Network error'))

        expect(logger).to receive(:warn).with("#{gem_name} couldn't be fetched")
        result = described_class.get_gem(gem_name, gem_version, logger)
        expect(result).to be_nil
      end

      it 'returns the correct version from response' do
        allow(RestClient::Request).to receive(:execute)
          .and_return(double(body: mock_response.to_json))

        result = described_class.get_gem(gem_name, gem_version, logger)
        expect(result['number']).to eq('7.0.1')
        expect(result['sha']).to eq('def456')
      end
    end
  end
end

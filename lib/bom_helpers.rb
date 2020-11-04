# frozen_string_literal: true

def purl(name, version)
  "pkg:gem/#{name}@#{version}"
end

def random_urn_uuid
  "urn:uuid:#{SecureRandom.uuid}"
end

def build_bom(gems)
  builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
    attributes = { 'xmlns' => 'http://cyclonedx.org/schema/bom/1.1', 'version' => '1', 'serialNumber' => random_urn_uuid }
    xml.bom(attributes) do
      xml.components do
        gems.each do |gem|
          xml.component('type' => 'library') do
            xml.name gem['name']
            xml.version gem['version']
            xml.description gem['description']
            xml.hashes  do
              xml.hash_ gem['hash'], alg: 'SHA-256'
            end
            if gem['license_id']
              xml.licenses do
                xml.license do
                  xml.id gem['license_id']
                end
              end
            elsif gem['license_name']
              xml.licenses do
                xml.license do
                  xml.name gem['license_name']
                end
              end
            end
            xml.purl gem['purl']
          end
        end
      end
    end
  end
  builder.to_xml
end

def get_gem(name, version)
  url = "https://rubygems.org/api/v1/versions/#{name}.json"
  begin
    response = RestClient.get(url)
    body = JSON.parse(response.body)
    body.select { |item| item['number'] == version.to_s }.first
  rescue StandardError
    @logger.warn("#{name} couldn't be fetched")
    nil
  end
end

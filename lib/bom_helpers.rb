def purl(name, version)
    purl = "pkg:gem/" + name + "@" + version.to_s
end

def random_urn_uuid()
  random_urn_uuid = "urn:uuid:" + SecureRandom.uuid
end

def build_bom(gems)
  builder = Nokogiri::XML::Builder.new(:encoding => "UTF-8") do |xml|
    attributes = {"xmlns" => "http://cyclonedx.org/schema/bom/1.1", "version" => "1", "serialNumber" => random_urn_uuid}
    xml.bom(attributes) do
      xml.components {
        gems.each do |gem|
          xml.component("type" => "library") {
            xml.name gem["name"]
            xml.version gem["version"]
            xml.description gem["description"]
            xml.hashes{
              xml.hash_ gem["hash"], :alg => "SHA-256"
            }
            if gem["license_id"]
              xml.licenses {
                xml.license{
                  xml.id gem["license_id"]
                }
              } 
            elsif gem["license_name"]
              xml.licenses {
                xml.license{
                  xml.name gem["license_name"]
                }
              }
            end
            xml.purl gem["purl"]
          }
        end
      }
    end
  end 
  builder.to_xml
end 

def get_gem(name, version)
  url = "https://rubygems.org/api/v1/versions/#{name}.json"
  begin
    response = RestClient.get(url)
    body = JSON.parse(response.body)
    body.select {|item| item["number"] == version.to_s}.first
  rescue 
    @logger.warn("#{name} couldn't be fetched")
    return nil
  end
end 
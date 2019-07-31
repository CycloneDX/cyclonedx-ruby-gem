def purl(name, version)
    purl = "pkg:gem/" + name + "@" + version.to_s
end

def random_urn_uuid()
  random_urn_uuid = "urn:uuid:" + SecureRandom.uuid
end

def build_bom(gems)

  xml_doc = REXML::Document.new('<?xml version="1.0" encoding="UTF-8"?>')
  bom_xml_element = xml_doc.add_element "bom", {"xmlns" => "http://cyclonedx.org/schema/bom/1.0", "version"=>"1", "serialNumber" => random_urn_uuid}
  components_xml_element = bom_xml_element.add_element "components"

  gems.each do |gem|
    component_xml_element = components_xml_element.add_element "component", {"type" => "library"}

    name_xml_element = component_xml_element.add_element "name"
    name_xml_element.text = gem["name"]

    version_xml_element = component_xml_element.add_element "version"
    version_xml_element.text = gem["version"]

    description_xml_element = component_xml_element.add_element "description"
    description_xml_element.text = gem["description"]

    hashes_xml_element = component_xml_element.add_element "hashes"
    hash_xml_element = hashes_xml_element.add_element "hash", {"alg" => "SHA-256"}
    hash_xml_element.text = gem["hash"]

    if gem["license_id"] || gem["license_name"]
      licenses_xml_element = component_xml_element.add_element "licenses"

      license_xml_element = licenses_xml_element.add_element "license"

      if gem["license_id"]
        license_id_xml_element = license_xml_element.add_element "id"
        license_id_xml_element.text = gem["license_id"]
      elsif gem["license_name"]
        license_name_xml_element = license_xml_element.add_element "id"
        license_name_xml_element.text = gem["license_name"]
      end
    end

    purl_xml_element = component_xml_element.add_element "purl"
    purl_xml_element.text = gem["purl"]
  end

  output=""
  xml_doc.write(output=output)
  output
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
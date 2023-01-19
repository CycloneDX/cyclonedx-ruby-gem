
class BomComponent
  DEFAULT_TYPE = "library".freeze
  HASH_ALG = 'SHA-256'.freeze

  def initialize(gem)
    @name = gem['name']
    @version = gem['version']
    @description = gem['description']
    @hash = gem['hash']
    @purl = gem['purl']
    @gem = gem
  end

  def hash_val
    component_hash = {
      "type": DEFAULT_TYPE,
      "name": @name,
      "version": @version,
      "description": @description,
      "purl": @purl,
      "hashes": [
          "alg": HASH_ALG,
          "content": @hash
      ]
    }

    if @gem['license_text'] || @gem['license_name']
      license_section = {
        license: {}
      }

      if @gem['license_id']
        license_section[:license][:id] = @gem['license_id']
      elsif @gem['license_name']
        license_section[:license][:name] = @gem['license_name']
      end

      if @gem['license_text']
        license_section[:license][:text] = { content: @gem['license_text'] }
      end

      component_hash[:licenses] = [license_section]
    end

    [component_hash]
  end
end


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
      "purl": @purl
    }

    # Add description only if it is available
    if @description
      component_hash[:"description"] = @description
    end

    # Add hash only if it is available
    if @hash
      component_hash[:"hashes"] = [
        "alg": HASH_ALG,
        "content": @hash
      ]
    end

    if @gem['license_id']
      component_hash[:"licenses"] = [
        "license": {
          "id": @gem['license_id']
        }
      ]
    elsif @gem['license_name']
      component_hash[:"licenses"] = [
        "license": {
          "name": @gem['license_name']
        }
      ]
    end

    [component_hash]

  end
end

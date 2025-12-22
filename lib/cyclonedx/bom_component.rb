# frozen_string_literal: true

require_relative 'field_accessor'

module Cyclonedx
  class BomComponent

    DEFAULT_TYPE = 'library'
    HASH_ALG = 'SHA-256'

    def initialize(gem)
      @gem = gem
      @name = fetch('name')
      @version = fetch('version')
      @description = fetch('description')
      @hash = fetch('hash')
      @purl = fetch('purl')
    end

    def hash_val(include_enrichment: false)
      component_hash = {
        type: DEFAULT_TYPE,
        name: @name,
        version: @version,
        description: @description,
        purl: @purl,
        hashes: [
          {
            alg: HASH_ALG,
            content: @hash
          }
        ]
      }

      if include_enrichment
        # Add bom-ref using the purl when present
        component_hash[:'bom-ref'] = @purl if @purl && !@purl.to_s.empty?
        # Add publisher using first author if present
        author = fetch('author')
        if author && !author.to_s.strip.empty?
          first_author = author.to_s.split(/[,&]/).first.to_s.strip
          component_hash[:publisher] = first_author unless first_author.empty?
        end
      end

      if fetch('license_id')
        component_hash[:licenses] = [
          {
            license: {
              id: fetch('license_id')
            }
          }
        ]
      elsif fetch('license_name')
        component_hash[:licenses] = [
          {
            license: {
              name: fetch('license_name')
            }
          }
        ]
      end

      [component_hash]
    end

    private

    # Safe accessor for Hash or OpenStruct-like objects
    def fetch(key)
      FieldAccessor._get(@gem, key)
    end
  end
end

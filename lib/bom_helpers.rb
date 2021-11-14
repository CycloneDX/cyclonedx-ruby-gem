# This file is part of CycloneDX Ruby Gem.
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) OWASP Foundation. All Rights Reserved.
#
# frozen_string_literal: true
def purl(name, version)
  "pkg:gem/#{name}@#{version}"
end

def random_urn_uuid
  "urn:uuid:#{SecureRandom.uuid}"
end

def build_bom(gems, format)
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

  xml = builder.to_xml

  # Format verified to be either xml (default) or json in setup
  if format == 'json'
    JSON.pretty_generate(Hash.from_xml(xml))
  else
    xml
  end

end

def get_gem(name, version)
  url = "https://rubygems.org/api/v1/versions/#{name}.json"
  begin
    RestClient.proxy = ENV['http_proxy']
    response = RestClient.get(url)
    body = JSON.parse(response.body)
    body.select { |item| item['number'] == version.to_s }.first
  rescue StandardError
    @logger.warn("#{name} couldn't be fetched")
    nil
  end
end

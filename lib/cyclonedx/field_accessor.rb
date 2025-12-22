# frozen_string_literal: true

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

module Cyclonedx
  # Shared utility for safe field access from Hash or OpenStruct-like objects
  module FieldAccessor
    module_function

    # Safe accessor for Hash or OpenStruct-like objects
    def _get(obj, key)
      if obj.respond_to?(:[]) && obj[key]
        obj[key]
      elsif obj.respond_to?(key)
        obj.public_send(key)
      end
    end
  end
end


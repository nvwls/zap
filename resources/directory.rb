#
# Author: Joseph J. Nuspl Jr. (<nuspl@nvwls.com>)
# Cookbook Name:: zap
# Resource:: directory
#
# Copyright:: 2013, Joseph J. Nuspl Jr.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

actions :delay, :run
default_action :delay

attribute :directory, kind_of: String, name_attribute: true
attribute :pattern, kind_of: String, default: '*'

# frozen_string_literal: true

#
# Cookbook:: zap
# Recipe:: apt_repos
#
# Author:: Joseph J. Nuspl Jr. <nuspl@nvwls.com>
#
# Copyright:: 2017-2021, Joseph J. Nuspl Jr.
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

zap 'apt_repos' do
  action :remove

  register :apt_repository

  immediately node['zap']['apt_repos']['immediately']

  collect do
    ::Dir
      .glob("/etc/apt/sources.list.d/#{node['zap']['apt_repos']['pattern']}.list")
      .map { |path| ::File.basename(path, '.list') }
  end
end

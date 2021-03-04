# frozen_string_literal: true

#
# Cookbook:: zap
# Recipe:: sudoers_d
#
#      Used in conjunctions with the sudo cookbook, zap /etc/sudoers.d files.
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

if ENV['TEST_KITCHEN']
  # Don't zap the vagrant sudoers file
  sudo 'vagrant' do
    action :nothing
  end
end

zap_directory '/etc/sudoers.d' do
  pattern node['zap']['sudoers_d']['pattern']

  register :sudo do |r|
    # sudo_filename
    "/etc/sudoers.d/#{r.name.gsub(/[\.~]/, '__')}"
  end
end

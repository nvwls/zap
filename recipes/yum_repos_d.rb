# encoding: utf-8
#
# Cookbook Name:: zap
# Recipe:: yum_repos_d
#
# Author:: Joseph J. Nuspl Jr. <nuspl@nvwls.com>
#
# Copyright:: 2014, Joseph J. Nuspl Jr.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.  See the License for the specific language governing
# permissions and limitations under the License.
#

zap_directory '/etc/yum.repos.d' do
  select do |r|
    case r.class.to_s
    when 'Chef::Resource::File', 'Chef::Resource::Template'
      r.name
    when 'Chef::Resource::YumRepository'
      "/etc/yum.repos.d/#{r.repositoryid}.repo"
    end
  end
end

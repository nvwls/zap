#
# Author: Joseph J. Nuspl Jr. (<nuspl@nvwls.com>)
# Cookbook Name:: zap
# Provider:: directory
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

action :delete do
  all = ::Dir.glob("#{@new_resource.name}/#{@new_resource.pattern}")
  return if all.empty?
  Chef::Log.debug "Found #{all.inspect}"

  @run_context.resource_collection.each do |r|
    if r.kind_of?(Chef::Resource::File) or r.kind_of?(Chef::Resource::Template)
      if all.delete(r.name)
        Chef::Log.debug "Keeping #{r.name}"
      end
    end
  end

  all.each do |path|
    r = Chef::Resource::File.new(path, @run_context)
    r.cookbook_name=(@new_resource.cookbook_name)
    r.recipe_name=(@new_resource.recipe_name)
    r.action(:delete)
    @run_context.resource_collection << r
  end
end

#
# Cookbook Name:: zap
# HWRP:: users
#
# Author:: Sander Botman. <sbotman@schubergphilis.com>
#
# Copyright:: 2014, Sander Botman.
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

require 'etc'
require_relative 'default.rb'

if defined?(ChefSpec)
  def delete_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:linux_user, :remove, resource_name) ||
      ChefSpec::Matchers::ResourceMatcher.new(:user, :remove, resource_name)
  end
end

# zap_users '/etc/passwd'
class Chef
  # resource
  class Resource::ZapUsers < Resource::Zap
    def initialize(name, run_context = nil)
      super

      # Set the resource name and provider and default action
      @action = :remove
      @resource_name = :zap_users
      @supports << :filter

      klass = ::Chef::ResourceResolver.resolve(:user, node: @run_context.node)
      register klass.new(nil).resource_name

      collect do
        all = []

        IO.foreach(path) do |line|
          u = Struct::Passwd.new(*line.chomp.split(':'))
          u.uid = u.uid.to_i
          u.gid = u.gid.to_i

          next if node['zap']['users']['keep'].include?(u.name)

          all << u.name if @filter.call(u)
        end

        all
      end
    end

    def path(arg = nil)
      set_or_return(:path, arg, kind_of: String, default: '/etc/passwd')
    end
  end
end

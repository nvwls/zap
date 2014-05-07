# encoding: utf-8
#
# Cookbook Name:: zap
# HWRP:: groups
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

# zap_groups '/etc/group'
class Chef
  # resource
  class Resource::ZapGroups < Resource::Zap
    def initialize(name, run_context = nil)
      super

      # Set the resource name and provider and default action
      @action = :remove
      @resource_name = :zap_groups
      @provider = Provider::ZapGroups
      @klass = Chef::Resource::Group
    end
  end

  # provider
  class Provider::ZapGroups < Provider::Zap
    def collect
      all = []

      group = ::File.exist?(@name) ? @name : '/etc/group'

      IO.foreach(group) do |line|
        g = Struct::Group.new(*line.chomp.split(':'))
        g.gid = g.gid.to_i

        next if node['zap']['groups']['keep'].include?(g.name)

        all << g.name if @filter.call(g)
      end

      all
    end
  end
end

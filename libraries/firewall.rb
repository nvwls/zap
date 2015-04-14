# encoding: utf-8
#
# Cookbook Name:: zap
# HWRP:: firewall
#
# Author:: Ronald Doorn <rdoorn@schubergphilis.com>
#
# Copyright:: 2015, Ronald Doorn.
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
require 'chef/platform'
require_relative 'default.rb'

# zap_firewall
class Chef
  # resource
  class Resource::ZapFirewall < Resource::Zap
    def initialize(name, run_context = nil)
      super
	
      # Set the resource name and provider and default action
      @action = :remove
      @resource_name = :zap_firewall
      @klass = Chef::Resource::FirewallRule rescue nil
      Chef::Log.warn "You are trying to zap a firewall rule, but the firewall LWRPs are not loaded! Did you forgot to depend on the firewall cookbook somewhere?" if @klass.nil?

      platform, version = Chef::Platform.find_platform_and_version(run_context.node)
      case platform
      when "ubuntu", "debian"
        Chef::Log.warn "Zap does not yet support Ufw"
      when "redhat", "centos", "amazon", "scientific"
        if version[0].to_i >= 7
          @provider = Provider::ZapFirewallFirewalld
        else
          @provider = Provider::ZapFirewallIptables
        end
      end
    end
  end
end

# encoding: utf-8
#
# Cookbook Name:: zap
# HWRP:: firewall
#
# Author:: Sander van Harmelen <svanharmelen@schubergphilis.com>
#
# Copyright:: 2015, Sander van Harmelen.
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

# zap_firewall
class Chef
  # provider
  class Provider::ZapFirewallWindows < Provider::Zap
    include Chef::Mixin::ShellOut

    def collect
      all = []

      cmd = shell_out!('netsh advfirewall firewall show rule name=all')
      cmd.stdout.each_line do |line|
        if line =~ /^Rule Name:\s+(.*)$/
          all << $1.chomp
          Chef::Log.debug("Zap output: found firwall rule '#{$1.chomp}'")
        end
      end

      all
    end

    # rubocop:disable MethodLength
    def iterate(act)
      return unless @new_resource.delayed || @new_resource.immediately

      all = @collector.call
      all.each do |rule|
        next if find(rule)

	r = zap(rule, act)
        r.raw rule
        if @new_resource.immediately
          r.run_action(act)
        else
          @run_context.resource_collection << r
        end

	@new_resource.updated_by_last_action(true)
      end
    end

    def find(item)
      Chef::Log.debug("Starting Zap search for firewall rule '#{item}'")
      return unless item

      @run_context.resource_collection.each do |r|
        next unless r.resource_name == :firewall_rule

        Chef::Log.debug("matching: [#{item}] to [#{r.name}] => #{item == r.name}")
        return true if item =~ /#{r.name}/
      end
      return false
    end
    # rubocop:enable MethodLength
  end
end

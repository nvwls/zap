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
require_relative 'default.rb'

# zap_firewall
class Chef
  # provider
  class Provider::ZapFirewallFirewalld < Provider::Zap
    def collect
      all = []

      cmd = Mixlib::ShellOut.new("firewall-cmd --direct --get-all-rules")
      cmd.run_command
      cmd.stdout.split("\n").each do |line|
        all << line
        Chef::Log.debug("Zap output: #{line}")
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
      Chef::Log.debug("Starting Zap search for #{item}")
      return unless item

      @run_context.resource_collection.each do |r|
        next unless r.resource_name == :firewall_rule
        p = Chef::Provider::FirewallRuleFirewalld.new(r, @run_context)
        rule = p.send('build_firewall_rule', p.new_resource.action.first)
        rule.gsub!(/'/, "'*")

        Chef::Log.debug("matching: [#{item.rstrip}] to [#{rule.rstrip}] => #{item.rstrip == rule.rstrip}")
        return true if item.rstrip =~ /#{rule.rstrip}/
      end
      return false
    end

    # rubocop:enable MethodLength
  end

end

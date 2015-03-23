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
  class Provider::ZapFirewallIptables < Provider::Zap
    def collect
      # Collect all set rules
      all = []

      cmd = Mixlib::ShellOut.new("iptables-save")
      cmd.run_command
      line_count=0
      ['INPUT', 'OUTPUT', 'FORWARD'].each do |chain|
        line_count = 0
        cmd.stdout.lines do |line|
          next if line !~ /#{chain}/
          next if line[0] != '-'
	        line_count += 1
          all << "#{line_count} #{line.chomp}"
          Chef::Log.debug("Zap output: #{line_count} #{line.chomp}")
        end
      end

      all
    end

    # rubocop:disable MethodLength
    def iterate(act)
      # Detect the rules that we set, and clean up if not found
      return unless @new_resource.delayed || @new_resource.immediately

      all = @collector.call
      all.each do |rule|
	      native_rule=rule.split(' ').drop(2).join(' ')
        next if find(rule)

	      r = zap(native_rule, act)
        r.raw native_rule
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
        p = Chef::Provider::FirewallRuleIptables.new(r, @run_context)
        rule = p.send('build_firewall_rule', p.new_resource.action.first)

        if p.new_resource.position
           rule.gsub!(/(INPUT|OUTPUT|FORWARD)\s(\d+)/, '\2' + " -A " + '\1')
        end

        Chef::Log.debug("matching: [#{item.rstrip}] to [#{rule.rstrip}] => #{item.rstrip == rule.rstrip}")
        return true if item.rstrip =~ /#{rule.rstrip}/
      end
      return false
    end

    # rubocop:enable MethodLength
  end

end

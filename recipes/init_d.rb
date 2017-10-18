#
# Cookbook Name:: zap
# Recipe:: iptables_d
#
#      Used in conjunctions with the iptables cookbook, zap iptables_rule files.
#
# Author:: Joseph J. Nuspl Jr. <nuspl@nvwls.com>
#
# Copyright:: 2017, Joseph J. Nuspl Jr.
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

zap 'init_d' do
  register :service do |r| # rubocop:disable SymbolProc
    r.service_name
  end

  collect do
    all = []
    cmd = shell_out!('/sbin/chkconfig --list')
    cmd.stdout.split("\n").each do |line|
      next if line !~ /^(\S+)\s+0:(on|off)\s/
      svc = Regexp.last_match(1)
      next if line !~ /\s\d:on\s/
      next unless File.fnmatch(node['zap']['init_d']['pattern'], svc)
      all << svc
    end
    all
  end

  purge do |svc|
    r = Chef::Resource::Execute.new("Disable #{svc}", @run_context)
    r.action(:run)
    r.command("chkconfig --level 0123456 #{svc} off")
    r
  end
end

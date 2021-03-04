# frozen_string_literal: true

#
# Cookbook:: zap
# Recipe:: init_d
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

zap 'init_d' do
  register :service do |r| # rubocop:disable Style/SymbolProc
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
    build_resource(:execute, "Disable #{svc}") do
      action :run
      command "chkconfig --level 0123456 #{svc} off"
    end
  end
end

# frozen_string_literal: true

#
# Cookbook:: zap
# HWRP:: groups
#
# Author:: Sander Botman. <sbotman@schubergphilis.com>
# Author:: Joseph J. Nuspl Jr. <nuspl@nvwls.com>
#
# Copyright:: 2014, Sander Botman.
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

require_relative 'default'

# chef
class Chef
  # resource
  class Resource
    # zap_groups '/etc/group'
    class ZapGroups < Chef::Resource::Zap
      provides :zap_groups

      property :path, String, default: '/etc/group'

      def initialize(name, run_context = nil)
        super

        @supports << :filter

        register :group do |r| # rubocop:disable Style/SymbolProc
          r.group_name
        end

        collect do
          all = []

          IO.foreach(path) do |line|
            g = Struct::Group.new(*line.chomp.split(':'))
            g.gid = g.gid.to_i

            next if node['zap']['groups']['keep'].include?(g.name)

            all << g.name if @filter.call(g)
          end

          all
        end

        purge do |id|
          build_resource(:group, id) do
            action :remove
          end
        end
      end
    end
  end
end

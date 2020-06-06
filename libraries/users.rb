# frozen_string_literal: true

#
# Cookbook:: zap
# HWRP:: users
#
# Author:: Sander Botman. <sbotman@schubergphilis.com>
# Author:: Joseph J. Nuspl Jr. <nuspl@nvwls.com>
#
# Copyright:: 2014, Sander Botman.
# Copyright:: 2017-2020, Joseph J. Nuspl Jr.
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
    # zap_users '/etc/passwd'
    class ZapUsers < Chef::Resource::Zap
      provides :zap_users

      property :path, String, default: '/etc/passwd'

      def initialize(name, run_context = nil)
        super

        @supports << :filter

        register :user, :linux_user do |r| # rubocop:disable Style/SymbolProc
          r.username
        end

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

        purge do |id|
          build_resource(:user, id) do
            action :remove
          end
        end
      end
    end
  end
end

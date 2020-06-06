# frozen_string_literal: true

#
# Cookbook:: zap
# HWRP:: crontab
#
# Author:: Joseph J. Nuspl Jr. <nuspl@nvwls.com>
#
# Copyright:: 2014-2020 Joseph J. Nuspl Jr.
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

if defined?(ChefSpec) # rubocop:disable ChefModernize/DefinesChefSpecMatchers
  def call_zap_crontab(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:zap_crontab, :delete, resource_name)
  end
end

# chef
class Chef
  # resource
  class Resource
    # zap_crontab 'USER'
    class ZapCrontab < Zap
      include ::Chef::Mixin::ShellOut

      provides :zap_crontab

      def initialize(name, run_context = nil)
        super

        register :cron do |r|
          r.name if r.user == @name
        end

        collect do
          all = []

          cmd = shell_out!("crontab -l -u #{@name}")
          cmd.stdout.split("\n").each do |line|
            if line =~ /^\# Chef Name: (.*)/
              # Ugly hack!!! Need to follow what the cron provider does
              all << Regexp.last_match(1)
            end
          end

          all
        end

        purge do |id|
          # cannot use build_resource
          r = ::Chef::Resource::Cron.new(id, @run_context)
          r.action(:delete)
          r.user(@name)
          r
        end
      end
    end
  end
end

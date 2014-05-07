# encoding: utf-8
#
# Cookbook Name:: zap
# HWRP:: crontab
#
# Author:: Joseph J. Nuspl Jr. <nuspl@nvwls.com>
#
# Copyright:: 2014, Joseph J. Nuspl Jr.
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

require_relative 'default.rb'

# zap_crontab 'USER'
class Chef
  # resource
  class Resource::ZapCrontab < Resource::Zap
    def initialize(name, run_context = nil)
      super

      # Set the resource name and provider
      @resource_name = :zap_crontab
      @provider = Provider::ZapCrontab
      @klass = Chef::Resource::Cron
    end
  end

  # provider
  class Provider::ZapCrontab < Provider::Zap
    def collect
      all = []

      cmd = Mixlib::ShellOut.new("crontab -l -u #{@new_resource.name}")
      cmd.run_command
      cmd.stdout.split("\n").each do |line|
        if line =~ /^\# Chef Name: (.*)/
          # Ugly hack!!! Need to follow what the cron provider does
          all << Regexp.last_match(1)
        end
      end

      all
    end
  end
end

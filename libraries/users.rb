# encoding: utf-8
#
# Cookbook Name:: zap
# HWRP:: users
#
# Author:: Sander Botman. <sbotman@schubergphilis.com>
#
# Copyright:: 2014, Sander Botman.
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

# zap_users '/etc/passwd'
class Chef
  # resource
  class Resource::ZapUsers < Resource::Zap
    def initialize(name, run_context = nil)
      super

      # Set the resource name and provider and default action
      @action = :remove
      @resource_name = :zap_users
      @provider = Provider::ZapUsers
      @klass = Chef::Resource::User
    end
  end

  # provider
  class Provider::ZapUsers < Provider::Zap
    def collect
      all = []

      passwd = ::File.exist?(@name) ? @name : '/etc/passwd'

      IO.foreach(passwd) do |line|
        u = Struct::Passwd.new(*line.chomp.split(':'))
        u.uid = u.uid.to_i
        u.gid = u.gid.to_i

        next if node['zap']['users']['keep'].include?(u.name)

        all << u.name if @filter.call(u)
      end

      all
    end
  end
end

# encoding: utf-8
#
# Cookbook Name:: zap
# HWRP:: yum_repos
#
# Author:: Sander van Harmelen. <svanharmelen@schubergphilis.com>
#
# Copyright:: 2014, Sander van Harmelen.
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

# zap_yum_repos '/etc/yum.repos.d'
class Chef
  # resource
  class Resource::ZapYumRepos < Resource::Zap
    def initialize(name, run_context = nil)
      super

      # Set some default values
      @resource_name = :zap_yum_repos
      @provider = Provider::ZapYumRepos
      @immediately = true
      @klass = Chef::Resource::YumRepository rescue nil
      Chef::Log.warn "You are trying to zap a yum repository, but the yum LWRPs are not loaded! Did you forgot to depend on the yum cookbook somewhere?" if @klass.nil?
    end
  end

  # provider
  class Provider::ZapYumRepos < Provider::Zap
    def collect
      return [] if @klass.first.nil?
      all = []

      # Find all repo files and extract repository names
      dir = ::File.directory?(@name) ? @name : '/etc/yum.repos.d'
      ::Dir.glob(::File.join(dir, "#{@new_resource.pattern}.repo")).each do |repo|
        all << ::File.basename(repo).chomp('.repo')
      end

      all
    end
  end
end

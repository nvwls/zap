# encoding: utf-8
#
# Cookbook Name:: zap
# HWRP:: apt_repos
#
# Author:: Helgi Þormar Þorbjörnsson <helgi@php.net>
#
# Copyright:: 2014, Helgi Þormar Þorbjörnsson
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

# zap_apt_repos '/etc/apt/sources.list.d'
class Chef
  # resource
  class Resource::ZapAptRepos < Resource::Zap
    def initialize(name, run_context = nil)
      super

      # Set some default values
      @resource_name = :zap_apt_repos
      @provider = Provider::ZapAptRepos
      @immediately = true
      @klass = Chef::Resource::AptRepository rescue nil
      Chef::Log.warn "You are trying to zap a apt repository, but the apt LWRPs are not loaded! Did you forgot to depend on the apt cookbook somewhere?" if @klass.nil?
    end
  end

  # provider
  class Provider::ZapAptRepos < Provider::Zap
    def collect
      return [] if @klass.first.nil?
      all = []

      # Find all repo files and extract repository names
      dir = ::File.directory?(@name) ? @name : '/etc/apt/sources.list.d'
      ::Dir.glob(::File.join(dir, "#{@new_resource.pattern}.list")).each do |repo|
        all << ::File.basename(repo).chomp('.list')
      end

      all
    end
  end
end

# encoding: utf-8
#
# Cookbook Name:: zap
# HWRP:: directory
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

# zap_directory 'DIR'
class Chef
  # resource
  class Resource::ZapDirectory < Resource::Zap
    def initialize(name, run_context = nil)
      super

      # Set the resource name and provider
      @resource_name = :zap_directory
      @provider = Provider::ZapDirectory
      @klass = [Chef::Resource::File, Chef::Resource::Template, Chef::Resource::Link]
      @recursive = false
      @path = ''
    end

    def recursive(arg = nil)
      set_or_return(:recursive, arg, equal_to: [true, false], default: false)
    end

    def path(arg = nil)
      set_or_return(:path, arg, kind_of: String, default: '')
    end
  end

  # provider
  class Provider::ZapDirectory < Provider::Zap
    def select(r)
      r.path if @klass.include?(r.class)
    end

    def collect
      path = @new_resource.name
      if @new_resource.respond_to?(:path) && !@new_resource.path.empty?
        path = @new_resource.path
      end
      walk(path)
    end

    private

    def walk(base)
      all = []
      base = base.match('\*') ? ::Dir.glob(base) : [ base ]
      base.each do |dir|
        ::Dir.entries(dir).each do |name|
          next if name == '.' || name == '..'
          path = ::File.join(dir, name)

          if ::File.directory?(path)
            if @new_resource.recursive
              all.concat walk(path)
            end
          elsif ::File.fnmatch(@new_resource.pattern, path)
            all.push path
          end
        end
      end
      all
    end

    def zap(name, act)
      klass = Chef::Resource::Link if ::File.symlink?(name)
      super(name, act, klass)
    end
  end
end

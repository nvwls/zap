#
# Cookbook Name:: zap
# HWRP:: directory
#
# Author:: Joseph J. Nuspl Jr. <nuspl@nvwls.com>
#
# Copyright:: 2014-2017, Joseph J. Nuspl Jr.
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

      register :file, :cookbook_file, :template, :link

      @recursive = false
      @path = name
    end

    def recursive(arg = nil)
      set_or_return(:recursive, arg, equal_to: [true, false], default: false)
    end

    def path(arg = nil)
      set_or_return(:path, arg, kind_of: String)
    end
  end

  # provider
  class Provider::ZapDirectory < Provider::Zap
    def collect
      walk(@new_resource.path)
    end

    private

    def walk(base)
      all = []

      dirs = if base =~ /\*/
               ::Dir.glob(base)
             else
               [base]
             end
      dirs.each do |dir|
        ::Dir.entries(dir).each do |name|
          next if name == '.' || name == '..'
          path = ::File.join(dir, name)

          if ::File.directory?(path)
            if @new_resource.recursive
              #
              all.concat walk(path)
            end
          elsif ::File.fnmatch(@new_resource.pattern, path)
            all.push path
          end
        end
      end
      all
    end

    def purge(name, _)
      r = if ::File.symlink?(name)
            Chef::Resource::Link.new(name, @run_context)
          else
            Chef::Resource::File.new(name, @run_context)
          end
      r.action(:delete)
      r
    end
  end
end

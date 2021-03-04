# frozen_string_literal: true

#
# Cookbook:: zap
# HWRP:: directory
#
# Author:: Joseph J. Nuspl Jr. <nuspl@nvwls.com>
#
# Copyright:: 2014-2021, Joseph J. Nuspl Jr.
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
    # zap_directory 'DIR'
    class ZapDirectory < Chef::Resource::Zap
      provides :zap_directory

      property :recursive, [true, false], default: false
      property :path, String

      def initialize(name, run_context = nil)
        super

        # Set the provider
        @provider = Provider::ZapDirectory
        @supports << :filter

        register :file, :cookbook_file, :template, :link
        @path = name
      end
    end
  end

  # provider
  class Provider
    # zap_directory
    class ZapDirectory < Chef::Provider::Zap
      def collect
        walk(@new_resource.path)
      end

      private

      def walk(base) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
        all = []

        dirs = if base =~ /\*/
                 ::Dir.glob(base)
               else
                 [base]
               end
        dirs.each do |dir|
          ::Dir.entries(dir).each do |name|
            next if %w(. ..).include?(name)

            path = ::File.join(dir, name)

            if ::File.directory?(path)
              if @new_resource.recursive
                all.concat walk(path)
              end
            elsif ::File.fnmatch(@new_resource.pattern, path)
              all.push path if @filter.call(path)
            end
          end
        end
        all
      end

      def purge(name)
        if ::File.symlink?(name)
          build_resource(:link, name) do
            action :delete
          end
        else
          build_resource(:file, name) do
            action :delete
          end
        end
      end
    end
  end
end

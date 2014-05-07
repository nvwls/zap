# encoding: utf-8
#
# Cookbook Name:: zap
# HWRP:: zap
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
class Chef
  # resource
  class Resource::Zap < Resource
    attr_writer :pattern
    attr_writer :delayed
    attr_writer :filter
    attr_writer :klass

    def initialize(name, run_context = nil)
      super

      @delayed = false
      @pattern = '*'

      # Set the resource name and provider
      @resource_name = :zap
      @provider = Provider::Zap

      # Set default actions and allowed actions
      @action = :delete
      @allowed_actions.push(:delete, :remove)
    end

    def pattern(arg = nil)
      set_or_return(:pattern, arg, kind_of: String)
    end

    def filter(&block)
      set_or_return(:filter, block, kind_of: Proc)
    end

    def delayed(arg = nil)
      if arg == true
        @delayed = true
      elsif @delayed == false
        r = dup
        r.delayed(true)
        @run_context.resource_collection << r
      end
      @delayed
    end

    def klass(arg = nil)
      set_or_return(:klass, arg, kind_of: [Array, Class, String])
    end
  end

  # provider
  class Provider::Zap < Provider
    def load_current_resource
      @name  = new_resource.name
      @klass = [new_resource.klass].flatten
      @match = new_resource.pattern
      @filter = new_resource.filter || proc { |o| true }
    end

    def action_delete
      iterate(:delete)
    end

    def action_remove
      iterate(:remove)
    end

    private

    def collect
      []
    end

    def select(r)
      @klass.include?(r.class) || @klass.include?(r.class.to_s)
    end

    # rubocop:disable MethodLength
    def iterate(act)
      return unless new_resource.delayed

      all = collect

      @run_context.resource_collection.each do |r|
        if select(r) && all.delete(r.name)
          #
          Chef::Log.info "#{@new_resource} keeping #{r}"
        end
      end

      all.each do |name|
        if ::File.fnmatch(@match, name)
          r = zap(name, act)
          @run_context.resource_collection << r
          Chef::Log.info "#{@new_resource} zapping #{r}"
        end
      end
    end
    # rubocop:enable MethodLength

    def zap(name, act)
      r = @klass.first.new(name, @run_context)
      r.cookbook_name = @new_resource.cookbook_name
      r.recipe_name = @new_resource.recipe_name
      r.action(act)
      r
    end
  end
end

# frozen_string_literal: true

#
# Cookbook:: zap
# HWRP:: zap
#
# Author:: Joseph J. Nuspl Jr. <nuspl@nvwls.com>
#
# Copyright:: 2014-2020, Joseph J. Nuspl Jr.
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

if defined?(ChefSpec) # rubocop:disable ChefModernize/DefinesChefSpecMatchers
  def call_zap_delete(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:zap, :delete, resource_name)
  end

  def call_zap_remove(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:zap, :remove, resource_name)
  end
end

# Chef
class Chef
  # resource
  class Resource
    # zap
    class Zap < Chef::Resource
      include Chef::DSL::DeclareResource

      provides :zap
      default_action :delete

      attr_reader :klass

      property :immediately, [true, false], default: false
      property :force, [true, false], default: false
      property :pattern, String, default: '*'

      def initialize(name, run_context = nil)
        super

        # registered resource names
        @klass = {}
        @klass.default = lambda { |_| nil }

        # supported features
        @supports = []

        @delayed = false

        @filter = lambda { |_| true }

        # Set the provider
        @provider = Provider::Zap

        # Set default actions and allowed actions
        @allowed_actions.push(:delete, :remove, :disable)
      end

      def filter(&block)
        if !block.nil? && !@supports.include?(:filter)
          Chef::Log.warn "#{@resource_name} does not support filter"
        end
        set_or_return(:filter, block, kind_of: Proc) # rubocop:disable ChefModernize/SetOrReturnInResources
      end

      def collect(&block)
        set_or_return(:collect, block, kind_of: Proc) # rubocop:disable ChefModernize/SetOrReturnInResources
      end

      def purge(&block)
        set_or_return(:purge, block, kind_of: Proc) # rubocop:disable ChefModernize/SetOrReturnInResources
      end

      def delayed(arg = nil)
        if arg == true
          @delayed = true
        elsif @delayed == false && immediately == false
          r = dup
          r.delayed(true)
          @run_context.resource_collection.all_resources << r
        end
        @delayed
      end

      def register(*multiple, &block)
        multiple.each do |name|
          cb = block

          if block.nil?
            obj = Chef::ResourceResolver.resolve(name, node: @run_context.node).new('')

            if obj.respond_to?(:path)
              cb = lambda { |r| r.path }
            else
              cb = lambda { |r| r.name }
            end
          end

          @klass[name] = cb
        end
      end
    end
  end

  # provider
  class Provider
    # zap
    class Zap < Chef::Provider
      def load_current_resource
        @name  = @new_resource.name
        @klass = @new_resource.klass
        @pattern = @new_resource.pattern
        @filter = @new_resource.filter
        @collect = @new_resource.collect || method(:collect)
        @purge = @new_resource.purge || method(:purge)
      end

      if Chef::VERSION.to_i < 13
        def whyrun_supported? # rubocop:disable ChefModernize/WhyRunSupportedTrue
          true
        end
      end

      def action_delete
        iterate(:delete)
      end

      def action_disable
        iterate(:disable)
      end

      def action_remove
        iterate(:remove)
      end

      private

      def collect
        raise ":collect undefined for #{@new_resource}"
      end

      # collect all existing resources
      # keep only those that match the specified pattern
      def existing
        @collect
          .call
          .select { |name| ::File.fnmatch(@pattern, name) }
      end

      def desired
        @run_context
          .resource_collection
          .map { |r| @klass[r.resource_name].call(r) }
          .reject(&:nil?)
      end

      def iterate(act)
        return if override_runlist?
        return unless @new_resource.delayed || @new_resource.immediately

        extraneous = existing - desired
        extraneous.each do |name|
          r = @purge.call(name)
          r.cookbook_name = @new_resource.cookbook_name
          r.recipe_name = @new_resource.recipe_name

          Chef::Log.debug "#{@new_resource} zapping #{r}"
          if @new_resource.immediately
            r.run_action(act)
          else
            @run_context.resource_collection << r
          end
        end

        @new_resource.updated_by_last_action(extraneous.any?)
      end

      def override_runlist?
        return if @run_context.node.override_runlist.empty?

        if @new_resource.force
          Chef::Log.warn "Forcing #{@new_resource} during override_runlist"
          false
        else
          Chef::Log.warn "Skipping #{@new_resource} during override_runlist"
          true
        end
      end

      def purge(id)
        type, = @klass.first
        build_resource(type, id) do
          action @new_resource.action
        end
      end
    end
  end
end

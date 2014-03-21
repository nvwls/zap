#
# Author: Joseph J. Nuspl Jr. (<nuspl@nvwls.com>)
# Cookbook Name:: zap
# Provider:: crontab
#
# Copyright:: 2013-2014, Joseph J. Nuspl Jr.
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

def action_delay
  r = @new_resource.dup
  r.action(:run)
  @run_context.resource_collection << r
end

def action_run
  all = []

  cmd = Mixlib::ShellOut.new("crontab -l -u #{@new_resource.name}")
  cmd.run_command
  cmd.stdout.split("\n").each do |line|
    if line =~ /^\# Chef Name: (.*)/
      name = Regexp.last_match(1)
      if ::File.fnmatch(@new_resource.pattern, name)
        Chef::Log.debug "Found #{name}"
        all << name
      else
        Chef::Log.debug "Skipping #{name}"
      end
    end
  end

  return if all.empty?

  @run_context.resource_collection.each do |r|
    if r.kind_of?(Chef::Resource::Cron)
      if all.delete(r.name)
        #
        Chef::Log.debug "Keeping #{r.name}"
      end
    end
  end

  all.each do |path|
    r = Chef::Resource::Cron.new(path, @run_context)
    r.cookbook_name(@new_resource.cookbook_name)
    r.recipe_name(@new_resource.recipe_name)
    r.action(:delete)
    @run_context.resource_collection << r
  end
end

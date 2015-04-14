zap Cookbook CHANGELOG
======================
This file is used to list changes made in each version of the zap cookbook.

v0.8.3
------
### Improvement
- Added recipe [zap::firewall] for support for the firewall cookbook (main caller)
- Added recipe [zap::firewall_iptables] adds iptables support to zap firewall recipe
- Added recipe [zap::firewall_firewalld] adds firewalld support to zap firewall recipe

v0.8.2
------
### Improvement
- Eliminate warnings on newer versions of ChefSpec

v0.8.1
------
### Bugfix
- Added ZapDirectory#select to return `path` instead of the default of `name`.

The following will now be properly recognized:

```ruby
file 'arbitrary name' do
  path '/the/real/path'
end
```

v0.8.0
------
### Improvement
- Added recursive option to zap_directory to remove all files under the
  specified directory

v0.5.2
------
### Improvement
- Refactored recipe[zap::yum_repos_d] into the zap_yum_repos resource provider
- Added an option to call zap immediately at a certain point in your Chef run

v0.5.1
------
### Improvement
- Added recipe[zap::yum_repos_d]

v0.5.0
------
### Improvement
- Added collect and select to the resource

v0.4.3
------
### Improvement
- Moved @filter.call back

v0.4.2
------
### Improvement
- Moved @filter.call into iterate

v0.4.1
------
### Improvement
- Fixed rubocop warning

v0.4.0
------
### Improvement
- Added klass keyword to DSL which can take a class,
  i.e. Chef::Resource::File, or string,
  i.e. 'Chef::Resource::YumRepository', or an array of classes or
  strings.

v0.3.0
------
### Improvement
- Added zap_users and zap_groups

v0.2.0
------
### Improvement
- Added filter for more complex, codified filtering

v0.1.1
------
### Improvement
- Log at info

v0.1.0
------
### Minor
- Refactored into an HWRP to allow better code reuse

v0.0.6
------
### Improvement
- Cleaned up Rubocop warnings

v0.0.5
------
### Improvement
- Added zap_crontab to zap the specified user's crontab

v0.0.4
------
### Improvement
- Use ::File.join instead of hardcoding slashes

v0.0.3
------
### Improvement
- Split zap_directory into two phases, :delay to move it to the end of
  the resource list, and :run to do the actual work.

v0.0.2
------
### Improvement
- Move zap_directory to the end of the resource list.

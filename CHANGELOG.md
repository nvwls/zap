zap Cookbook CHANGELOG
======================
This file is used to list changes made in each version of the zap cookbook.

v1.1.0
### Minor
- Add *immediately* support to `zap::apt_repos` and `zap::yum_repos`

v1.0.2
### Enhancement
- Add `zap::init_d` to disable sysv-init services on centos-6

v1.0.1
### Enhancement
- Add `zap::sudoers_d` to prune `sudo` resources from /etc/sudoers.d

v1.0.0
### Breaking change
- Rewrote to support custom resources
- Remove `zap_firewall` as v2.6.2 of the firewall cookbook manages the ruleset as a whole
- Remove `zap_apt_repos` in favor of the `zap::apt_repos` recipe
- Remove `zap_yum_repos` in favor of the `zap::yum_repos` recipe

v0.15.1
### Bugfix
- Fix bug with filter property lamba expression

v0.15.0
### Enhancement
- Add `force` to force running of `zap` when there is an override_runlist
  Addresses https://github.com/nvwls/zap/issues/36

v0.14.0
### Bugfix
- Fix issues with zap_crontab and non-root cron

v0.13.1
### Improvement
- added unit tests for `zap_groups`

v0.13.0
### Bugfix
- Fix rubocop and foodcritic lint

v0.12.0
### Improvement
- added unit tests for zap_users and zap_yum_repos
- adapt logic to make it compatible with versions 12.14 and higher

v0.11.4
-------
### Enhancement
Bump version for tag

v0.11.3
-------
### Enhancement
Using stove for upload

v0.11.2
-------
### Enhancement
- Display a warning if a filter is given but the provider does not support it.

v0.11.1
-------
### Bugfix
- Apply @pattern before entering `converge_by`

v0.11.0
-------
### Enhancement
- Reworked to use `converge_by`

v0.10.0
-------
### Enhancement
- Allow klass to be passed into zap()
- zap_directory will now remove symlinks

v0.9.1
------
### Bugfix
- Internally @klass should be an array

v0.9.0
------
### Improvement
- Reworked klass to convert string into class
- Added recipe [zap::cron_d] to remove /etc/cron.d entries

v0.8.7
------
### Improvement
- Added recipe [zap::firewall_windows] adds Windows Firewall support to zap firewall recipe

v0.8.6
------
### Enhancement
- Support using a descriptive resource name; added path var to zap_directory

v0.8.5
------
### Bugfix
- Using the shovel operator in chef 12 results in the resource being
  added directly after the current resource, rather than at the end
  of the resource list. [joyofhex]

v0.8.4
------
### Bugfix
- Support globbed directories, e.g. `/home/*/.ssh`

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

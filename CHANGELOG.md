zap Cookbook CHANGELOG
======================
This file is used to list changes made in each version of the zap cookbook.

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

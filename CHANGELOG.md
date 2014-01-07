zap Cookbook CHANGELOG
======================
This file is used to list changes made in each version of the zap cookbook.

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

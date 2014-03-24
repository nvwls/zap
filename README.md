zap
===

Library cookbook for building authoritative resource sets.

One of the common pitfalls in chef land is the pattern of one deleting a
resource definition from a recipe and the user wondering why the resource still
exists on the system.

For example, on Monday a cronjob is added:

```ruby
cron 'collect stats' do
  action	:create
  minute	0
  command '/usr/local/bin/collect-stats | mailto ops@nvwls.com'
end
```

After a few days, the issue is figured out and that cron resource is removed
from the recipe.  After uploading the new cookbook, they wonder why they are
still receiving email.

The issue that chef is great for describing actions.  I mean, *action* is part
of the DSL.

At the 2013 Opscode Communit Summit, Matt Ray and I had discussion regarding
this issue.  The name *authoritative cookbook* was coined.  If chef is deploying
files to a .d directory, if there are files in that directory not converged by a
resource, those files should be removed.

This pattern has been added to https://github.com/Youscribe/sysctl-cookbook

Resource/Provider
=================

zap_directory
-------------

## Actions

- **:delete** - Delete files in a directory

## Attribute Parameters

- **pattern** - Pattern of files to match, i.e. `*.conf`, defaults to `*`

### Examples

```ruby
zap_directory '/etc/sysctl.d' do
  pattern '*.conf'
end
```

zap_crontab
-----------

## Actions

- **:delete** - Delete jobs from a user's crontab

## Attribute Parameters

- **pattern** - Pattern of job names match, i.e. `test \#*`, defaults to `*`

### Examples

```ruby
zap_crontab 'root' do
  pattern 'test \#*'
end
```

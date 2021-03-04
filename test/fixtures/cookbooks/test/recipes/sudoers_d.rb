# frozen_string_literal: true

node.default['authorization']['sudo']['include_sudoers_d'] = true

include_recipe 'sudo::default'

execute 'test setup' do
  command <<-COMMAND
  touch /etc/sudoers.d/obsolete
  touch /etc/sudoers.d/foo.bar
  touch /etc/sudoers.d/foo_bar
  touch /etc/sudoers.d/baz~
  touch /etc/sudoers.d/baz_
  COMMAND
end

include_recipe 'zap::sudoers_d'

sudo 'tomcat' do
  user      '%tomcat'
  commands  ['/etc/init.d/tomcat restart']
end

sudo 'foo.bar' do
  user      '%wheel'
  commands  ['/bin/true']
end

sudo 'baz~' do
  user      '%wheel'
  commands  ['/bin/false']
end

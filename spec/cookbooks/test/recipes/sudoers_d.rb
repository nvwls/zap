node.default['authorization']['sudo']['include_sudoers_d'] = true

include_recipe 'sudo::default'

execute 'test setup' do
  command <<COMMAND
touch #{node['authorization']['sudo']['prefix']}/sudoers.d/obsolete
COMMAND
end

include_recipe 'zap::sudoers_d'

sudo 'tomcat' do
  user      '%tomcat'
  commands  ['/etc/init.d/tomcat restart']
end

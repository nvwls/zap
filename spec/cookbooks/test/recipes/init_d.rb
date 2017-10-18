execute 'test prep' do
  command <<COMMAND
chkconfig postfix on &>/dev/null
chkconfig --level 4 rsyslog on &>/dev/null
COMMAND
end

service 'crond' do
  action :enable
end

service 'iptables' do
  action :nothing
end

service 'netfs' do
  action :nothing
end

service 'network' do
  action :nothing
end

include_recipe 'zap::init_d'

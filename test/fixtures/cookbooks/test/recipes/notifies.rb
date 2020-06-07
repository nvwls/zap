# frozen_string_literal: true

execute 'prep' do
  command <<-COMMAND
  rm -f /tmp/notifies
  rm -f /tmp/subscribes
  mkdir -p /etc/conf.d
  COMMAND
end

execute 'touch /etc/conf.d/obsolete' do
  only_if { node['obsolete'] }
end

file '/tmp/notifies' do
  action :nothing
end

zap_directory '/etc/conf.d' do
  notifies :touch, 'file[/tmp/notifies]'
end

file '/tmp/subscribes' do
  action :nothing
  subscribes :touch, 'zap_directory[/etc/conf.d]'
end

# frozen_string_literal: true

include_recipe 'iptables::default'

if node['platform_version'].to_i == 6
  edit_resource!(:package, 'iptables') do
    package_name %w(iptables iptables-ipv6)
  end
end

execute 'test setup' do
  command <<-COMMAND
  echo '-A FWR -p tcp -m tcp --dport 22 -j ACCEPT' >/etc/iptables.d/ssh
  COMMAND
end

iptables_rule 'http_8080' do
  action :enable
  lines <<-LINES
  -A FWR -p tcp -m tcp --dport 8080 -j ACCEPT
  LINES
end

include_recipe 'zap::iptables_d'

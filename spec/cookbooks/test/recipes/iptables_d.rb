include_recipe 'iptables::default'

execute 'test setup' do
  command <<EOF
echo '-A FWR -p tcp -m tcp --dport 22 -j ACCEPT' >/etc/iptables.d/ssh
EOF
end

iptables_rule 'http_8080' do
  action :enable
  lines <<EOF
-A FWR -p tcp -m tcp --dport 80 -j ACCEPT
EOF
end

include_recipe 'zap::iptables_d'

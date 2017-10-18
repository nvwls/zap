execute 'test prep' do
  command <<COMMAND
groupadd input -g 999 &>/dev/null
groupadd larry &> /dev/null
groupadd curly &> /dev/null
COMMAND
end

group 'moe'

group 'input' do
  action :nothing
end

zap_groups '/etc/group' do
  pattern	node['groups']['pattern']
  filter do |g|
    g.gid >= 500
  end
end

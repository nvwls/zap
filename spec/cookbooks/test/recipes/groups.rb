group 'moe'

zap_groups '/etc/group' do
  pattern	node['groups']['pattern']
  filter do |g|
    g.gid > 500
  end
end

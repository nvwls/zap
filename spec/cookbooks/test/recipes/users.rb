user 'moe'

zap_users '/etc/passwd' do
  pattern	node['users']['pattern']
  filter do |u|
    u.uid > 500
  end
end

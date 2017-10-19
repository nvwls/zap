execute 'test prep' do
  command <<COMMAND
cat >/etc/apt/sources.list.d/dummy.list <<EOF
deb      [trusted=yes] "https://dummy.net/stable-apt" wheezy main
EOF
COMMAND
end

include_recipe 'zap::apt_repos'

apt_repository 'chef-stable' do
  uri 'https://packages.chef.io/stable-apt'
  components ['main']
  trusted true
  cache_rebuild false
end

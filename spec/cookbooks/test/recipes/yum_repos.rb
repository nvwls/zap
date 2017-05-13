zap_yum_repos '/etc/yum.repos.d'

yum_repository 'chef-stable' do
  description 'Chef Software Inc stable channel'
  baseurl "https://packages.chef.io/stable-yum/el/#{node['platform_version'].split('.').first}/$basearch"
  make_cache false
end

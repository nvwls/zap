# encoding: UTF-8

yum_repository 'os' do
  description 'os'
  baseurl 'https://www.example.com/repo/os'
end

zap_yum_repos '/etc/yum.repos.d' do
  delayed true
end

# encoding: UTF-8

file '/etc/profile.d/lang.sh'

file '/etc/profile.d/sub/keep.sh' do
  action :nothing
end

zap_directory '/etc/profile.d' do
  pattern	node['directory']['pattern']
  recursive	node['directory']['recursive']
end

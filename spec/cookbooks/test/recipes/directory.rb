file '/etc/profile.d/lang.sh'

file 'we want to keep this' do
  path '/etc/profile.d/sub/keep.sh'
  action :nothing
end

zap_directory '/etc/profile.d' do
  pattern	node['directory']['pattern']
  recursive	node['directory']['recursive']
end

zap_directory 'clean up SSH directories' do
  path '/home/*/.ssh'
end

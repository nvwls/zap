# encoding: UTF-8

zap_directory '/etc/conf.d'

`mkdir -p /etc/conf.d`
`touch /etc/conf.d/cshrc`
`ln -nsf /etc/profile.d/.bashrc /etc/conf.d/bashrc`

link '/etc/conf.d/logout' do
  to '/etc/skel/.bash_logout'
  link_type :hard
end

link '/etc/conf.d/profile' do
  to '/etc/skel/.bash_profile'
end

file '/etc/conf.d/lang' do
  content <<EOF
export LANG=en_US
EOF
end

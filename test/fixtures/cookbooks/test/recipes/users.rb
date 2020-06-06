# frozen_string_literal: true

execute 'test prep' do
  command <<-COMMAND
  useradd -s larry &>/dev/null
  useradd curly &>/dev/null
  useradd waldo &>/dev/null
  COMMAND
end

user 'moe'

user 'vagrant' do
  action :nothing
end

zap_users '/etc/passwd' do
  pattern node['users']['pattern'] if node['users']['pattern']
  filter do |u|
    u.uid >= 500
  end
end

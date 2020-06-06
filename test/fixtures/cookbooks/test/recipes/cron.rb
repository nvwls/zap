# frozen_string_literal: true

file '/tmp/cron' do
  content <<-CONTENT
  # Chef Name: a
  * * * * * echo a

  # Chef Name: b
  * * * * * echo b

  # Chef Name: c
  * * * * * echo c
  CONTENT
end

execute 'test prep' do
  command <<-COMMAND
  cat >/tmp/empty </dev/null

  crontab -u root /tmp/cron
  crontab -u nobody /tmp/cron
  crontab -u daemon /tmp/empty
  COMMAND
end

cron 'a' do
  action :nothing
end

cron 'b' do
  command 'echo b'
  user 'nobody'
end

cron 'c' do
  command 'echo c'
end

zap_crontab 'root'
zap_crontab 'nobody'
zap_crontab 'daemon'

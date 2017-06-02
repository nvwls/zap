cron 'larry' do
  action :nothing
end

cron 'moe' do
  command 'true'
  user 'nobody'
end

cron 'curly' do
  minute  0
  hour    23
  command 'true'
end

zap_crontab 'root'
zap_crontab 'nobody'

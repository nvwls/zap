# encoding: UTF-8

zap 'cron_d' do
  klass 'Chef::Resource::CronD'
  collect do
    Dir.glob('/etc/cron.d/*').map { |path| File.basename(path) }
  end
end

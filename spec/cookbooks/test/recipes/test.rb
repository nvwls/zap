# encoding: utf-8

base = '/etc/sysctl.d'

system("mkdir #{base}/sub")
system("touch #{base}/sub/{one,two}")

file "#{base}/foo" do
  content 'foo'
end

system("touch #{base}/bar")

template "#{base}/bar" do
  action :nothing
end

system("touch #{base}/bar.conf")

zap_directory base do
#  pattern	"*.conf"
#  action	:nothing
end

execute "ls -alR #{base}"

cron 'test #1' do
  command 'true'
end

zap_crontab 'root' do
  pattern 'test \#*'
end

system("mkdir -p /test/{a,b,c}")
system("touch /test/{a,b,c,.}/this.conf")

file '/test/this.conf' do
  action :nothing
end

zap_directory '/test' do
  recursive true
end

base = '/etc/sysctl.d'

`mkdir -p #{base}/sub`
`touch #{base}/sub/{one,two}`

file "#{base}/foo" do
  content 'foo'
end

`touch #{base}/bar`

template "#{base}/bar" do
  action :nothing
end

`touch #{base}/bar.conf`

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

`mkdir -p /test/{a,b,c}`
`touch /test/{a,b,c,.}/this.conf`

file '/test/this.conf' do
  action :nothing
end

zap_directory '/test' do
  recursive true
end

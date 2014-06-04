# encoding: utf-8

base = '/etc/sysctl.d'

file "#{base}/foo" do
  content 'foo'
end

system("touch #{base}/bar")

template "#{base}/bar" do
  action :nothing
end

system("touch #{base}/bar.conf")

zap base do
  klass [Chef::Resource::File, 'Chef::Resource::Template']
  collect { ::Dir.glob("#{base}/*") }
end

base = '/etc/raw.d'

`mkdir -p #{base}`

file "#{base}/foo" do
  content 'foo'
end

`touch #{base}/bar`

template "#{base}/bar" do
  action :nothing
end

`touch #{base}/bar.conf`

zap base do
  klass [Chef::Resource::File, 'Chef::Resource::Template']
  collect { ::Dir.glob("#{base}/*") }
end

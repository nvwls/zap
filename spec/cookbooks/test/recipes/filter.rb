base = '/tmp/filter.d'

`mkdir -p #{base}`

zap_directory base do
  filter do |u|
    u.uid > 500
  end
end

execute 'test prep' do
  command <<COMMAND
cat >/tmp/cron <<EOF
# Chef Name: a
* * * * * echo a

# Chef Name: b
* * * * * echo b

# Chef Name: c
* * * * * echo c
EOF

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

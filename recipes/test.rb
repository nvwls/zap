base = "/etc/sysctl.d"

file "#{base}/foo" do
  content "foo"
end

system("touch #{base}/bar")
system("touch #{base}/bar.conf")

zap_directory base do
#  pattern	"*.conf"
#  action	:nothing
end

execute "ls -l #{base}"

cron "test #1" do
  command "true"
end

zap_crontab "root" do
  pattern "test \#*"
end

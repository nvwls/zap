diff --git a/recipes/test.rb b/recipes/test.rb
deleted file mode 100644
index 882af9a..0000000
--- a/recipes/test.rb
+++ /dev/null
@@ -1,30 +0,0 @@
-# encoding: utf-8
-
-base = '/etc/sysctl.d'
-
-file "#{base}/foo" do
-  content 'foo'
-end
-
-system("touch #{base}/bar")
-
-template "#{base}/bar" do
-  action :nothing
-end
-
-system("touch #{base}/bar.conf")
-
-zap_directory base do
-#  pattern	"*.conf"
-#  action	:nothing
-end
-
-execute "ls -l #{base}"
-
-cron 'test #1' do
-  command 'true'
-end
-
-zap_crontab 'root' do
-  pattern 'test \#*'
-end

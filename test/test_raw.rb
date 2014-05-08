diff --git a/recipes/test_raw.rb b/recipes/test_raw.rb
deleted file mode 100644
index 5ad029c..0000000
--- a/recipes/test_raw.rb
+++ /dev/null
@@ -1,20 +0,0 @@
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
-zap base do
-  klass [Chef::Resource::File, 'Chef::Resource::Template']
-  collect { ::Dir.glob("#{base}/*") }
-end

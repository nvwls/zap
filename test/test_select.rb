diff --git a/recipes/test_select.rb b/recipes/test_select.rb
deleted file mode 100644
index 84ebcaf..0000000
--- a/recipes/test_select.rb
+++ /dev/null
@@ -1,12 +0,0 @@
-# encoding: utf-8
-
-zap_directory '/etc/yum.repos.d' do
-  select do |r|
-    case r.class.to_s
-    when 'Chef::Resource::File', 'Chef::Resource::Template'
-      r.name
-    when 'Chef::Resource::YumRepository'
-      "/etc/yum.repos.d/#{r.repositoryid}.repo"
-    end
-  end
-end

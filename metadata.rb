name              'zap'
maintainer        'Joseph J. Nuspl Jr.'
maintainer_email  'nuspl@nvwls.com'
license           'Apache 2.0'
description       'Provides HWRPs for creating authoritative resources'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '1.1.0'

%w(amazon centos fedora oracle redhat scientific).each do |os|
  supports os
end

%w(debian ubuntu freebsd windows).each do |os|
  supports os
end

source_url 'https://github.com/nvwls/zap' if respond_to?(:source_url)
issues_url 'https://github.com/nvwls/zap/issues' if respond_to?(:issues_url)

chef_version '>= 12.1' if respond_to?(:chef_version)

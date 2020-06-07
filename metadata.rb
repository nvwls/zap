# frozen_string_literal: true

name              'zap'
maintainer        'Joseph J. Nuspl Jr.'
maintainer_email  'nuspl@nvwls.com'
license           'Apache-2.0'
description       'Provides HWRPs for creating authoritative resources'
version           '2.1.2'

%w(amazon centos fedora oracle redhat scientific).each do |os|
  supports os
end

%w(debian ubuntu freebsd windows).each do |os|
  supports os
end

source_url 'https://github.com/nvwls/zap'
issues_url 'https://github.com/nvwls/zap/issues'

chef_version '>= 12.1'

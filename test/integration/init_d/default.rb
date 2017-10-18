describe sysv_service('crond') do
  it { should be_enabled }
end

describe sysv_service('iptables') do
  it { should be_enabled }
end

describe sysv_service('netfs') do
  it { should be_enabled }
end

describe sysv_service('network') do
  it { should be_enabled }
end

describe sysv_service('postfix') do
  it { should_not be_enabled }
end

describe sysv_service('rsyslog') do
  it { should_not be_enabled }
end

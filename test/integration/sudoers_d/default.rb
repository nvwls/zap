describe file('/etc/sudoers.d/README') do
  it { should exist }
end

describe file('/etc/sudoers.d/obsolete') do
  it { should_not exist }
end

describe file('/etc/sudoers.d/tomcat') do
  it { should exist }
end

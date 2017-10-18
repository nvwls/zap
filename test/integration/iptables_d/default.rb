describe file('/etc/iptables.d/ssh') do
  it { should_not exist }
end

describe file('/etc/iptables.d/http_8080') do
  it { should exist }
end

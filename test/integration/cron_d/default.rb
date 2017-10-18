describe file('/etc/cron.d/a') do
  it { should_not exist }
end

describe file('/etc/cron.d/b') do
  it { should exist }
end

describe file('/etc/cron.d/c') do
  it { should_not exist }
end

describe file('/etc/cron.d/d') do
  it { should exist }
end

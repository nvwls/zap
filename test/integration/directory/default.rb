describe file('/etc/conf.d/a') do
  it { should_not exist }
end

describe file('/etc/conf.d/b') do
  it { should_not exist }
end

describe directory('/etc/conf.d/c') do
  it { should exist }
end

describe file('/etc/conf.d/link') do
  it { should exist }
end

describe file('/etc/conf.d/symlink') do
  it { should exist }
end

describe file('/etc/conf.d/file') do
  it { should exist }
end

describe file('/etc/conf.d/cookbook_file') do
  it { should exist }
end

describe file('/etc/conf.d/template') do
  it { should exist }
end

describe directory('/etc/conf.d/dir') do
  it { should exist }
end

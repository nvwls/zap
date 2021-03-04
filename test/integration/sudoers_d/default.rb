# frozen_string_literal: true

describe file('/etc/sudoers.d/README') do
  it { should exist }
end

describe file('/etc/sudoers.d/obsolete') do
  it { should_not exist }
end

describe file('/etc/sudoers.d/tomcat') do
  it { should exist }
end

describe file('/etc/sudoers.d/foo__bar') do
  it { should exist }
end

describe file('/etc/sudoers.d/foo.bar') do
  it { should_not exist }
end

describe file('/etc/sudoers.d/foo_bar') do
  it { should_not exist }
end

describe file('/etc/sudoers.d/baz__') do
  it { should exist }
end

describe file('/etc/sudoers.d/baz~') do
  it { should_not exist }
end

describe file('/etc/sudoers.d/baz_') do
  it { should_not exist }
end

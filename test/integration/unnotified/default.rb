# frozen_string_literal: true

describe file('/etc/notifies') do
  it { should_not exist }
end

describe file('/etc/subscribes') do
  it { should_not exist }
end

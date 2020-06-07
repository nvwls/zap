# frozen_string_literal: true

describe file('/tmp/notifies') do
  it { should exist }
end

describe file('/tmp/subscribes') do
  it { should exist }
end

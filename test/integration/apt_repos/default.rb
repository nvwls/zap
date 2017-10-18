describe apt('https://dummy.net/stable-apt') do
  it { should_not exist }
end

describe apt('https://packages.chef.io/stable-apt') do
  it { should exist }
end

describe yum.repo('a') do
  it { should_not exist }
end

describe yum.repo('chef-stable') do
  it { should exist }
end

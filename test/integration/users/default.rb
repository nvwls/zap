describe user('root') do
  it { should exist }
end

describe user('larry') do
  it { should_not exist }
end

describe user('moe') do
  it { should exist }
end

describe user('curly') do
  it { should_not exist }
end

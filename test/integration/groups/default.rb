describe group('root') do
  it { should exist }
end

describe group('daemon') do
  it { should exist }
end

describe group('input') do
  it { should exist }
end

describe group('larry') do
  it { should_not exist }
end

describe group('moe') do
  it { should exist }
end

describe group('curly') do
  it { should_not exist }
end

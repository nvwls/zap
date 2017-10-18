describe crontab('root') do
  its('commands') { should include 'echo a' }
  its('commands') { should_not include 'echo b' }
  its('commands') { should include 'echo c' }
end

describe crontab('nobody') do
  its('commands') { should_not include 'echo a' }
  its('commands') { should include 'echo b' }
  its('commands') { should_not include 'echo c' }
end

describe crontab('daemon') do
  its('commands') { should_not include 'echo a' }
  its('commands') { should_not include 'echo b' }
  its('commands') { should_not include 'echo c' }
end

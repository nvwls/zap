require 'spec_helper'

describe 'test::cron' do
  before do
    root = <<EOF
# Chef Name: larry
* * * * * true

# Chef Name: moe
* * * * * true

# Chef Name: curly
* * * * * true

# Chef Name: stooges
* * * * * true
EOF
    nobody = <<EOF
# Chef Name: larry
* * * * * true

# Chef Name: moe
* * * * * true

# Chef Name: curly
* * * * * true
EOF
    allow(Mixlib::ShellOut).to receive(:new).and_call_original
    allow(Mixlib::ShellOut).to receive(:new)
      .with('crontab -l -u root')
      .and_return(double(run_command: nil, stdout: root))
    allow(Mixlib::ShellOut).to receive(:new)
      .with('crontab -l -u nobody')
      .and_return(double(run_command: nil, stdout: nobody))
  end

  let :runner do
    ChefSpec::SoloRunner.new(step_into: 'zap_crontab') do |node|
    end.converge(described_recipe)
  end

  it 'converges' do
    expect(runner).to call_zap_crontab('root')
    expect(runner).not_to delete_cron('larry').with(user: 'root')
    expect(runner).to delete_cron('moe').with(user: 'root')
    expect(runner).not_to delete_cron('curly').with(user: 'root')
    expect(runner).to delete_cron('stooges').with(user: 'root')

    expect(runner).to call_zap_crontab('nobody')
    expect(runner).to delete_cron('larry').with(user: 'nobody')
    expect(runner).not_to delete_cron('moe').with(user: 'nobody')
    expect(runner).to delete_cron('curly').with(user: 'nobody')
  end
end

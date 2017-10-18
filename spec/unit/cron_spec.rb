require 'spec_helper'
require_relative '../../libraries/crontab'

describe 'test::cron' do
  before do
    crontab = <<EOF
# Chef Name: a
* * * * * echo a

# Chef Name: b
* * * * * echo b

# Chef Name: c
* * * * * echo c
EOF
    allow_any_instance_of(Chef::Resource).to receive(:shell_out!)
      .and_call_original
    allow_any_instance_of(Chef::Resource).to receive(:shell_out!)
      .with('crontab -l -u root')
      .and_return(double(stdout: crontab))
    allow_any_instance_of(Chef::Resource).to receive(:shell_out!)
      .with('crontab -l -u nobody')
      .and_return(double(stdout: crontab))
    allow_any_instance_of(Chef::Resource).to receive(:shell_out!)
      .with('crontab -l -u daemon')
      .and_return(double(stdout: ''))
  end

  subject do
    ChefSpec::SoloRunner.new(step_into: 'zap_crontab') do |node|
    end.converge(described_recipe)
  end

  it { is_expected.to call_zap_crontab('root') }
  it { is_expected.not_to delete_cron('a').with(user: 'root') }
  it { is_expected.to     delete_cron('b').with(user: 'root') }
  it { is_expected.not_to delete_cron('c').with(user: 'root') }

  it { is_expected.to call_zap_crontab('nobody') }
  it { is_expected.to     delete_cron('a').with(user: 'nobody') }
  it { is_expected.not_to delete_cron('b').with(user: 'nobody') }
  it { is_expected.to     delete_cron('c').with(user: 'nobody') }

  it { is_expected.to call_zap_crontab('daemon') }
  it { is_expected.not_to delete_cron('a').with(user: 'daemon') }
  it { is_expected.not_to delete_cron('b').with(user: 'daemon') }
  it { is_expected.not_to delete_cron('c').with(user: 'daemon') }
end

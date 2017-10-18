require 'spec_helper'

describe 'test::force' do
  before do
    root = <<EOF
# Chef Name: obsolete
* * * * * true
EOF
    allow_any_instance_of(Chef::Resource).to receive(:shell_out!)
      .and_call_original
    allow_any_instance_of(Chef::Resource).to receive(:shell_out!)
      .with('crontab -l -u root')
      .and_return(double(stdout: root))
  end

  context '!override, !force' do
    subject do
      ChefSpec::SoloRunner.new(step_into: 'zap_crontab') do |node|
        allow(node).to receive(:override_runlist).and_return([])
      end.converge(described_recipe)
    end

    it { is_expected.to call_zap_crontab('root') }
    it { is_expected.to delete_cron('obsolete') }
  end

  context '!override, force' do
    subject do
      ChefSpec::SoloRunner.new(step_into: 'zap_crontab') do |node|
        allow(node).to receive(:override_runlist).and_return([])
        node.override['force_zap_on_override'] = true
      end.converge(described_recipe)
    end

    it { is_expected.to call_zap_crontab('root') }
    it { is_expected.to delete_cron('obsolete') }
  end

  context 'override, !force' do
    before do
      expect(Chef::Log).to receive(:warn).with('Skipping zap_crontab[root] during override_runlist')
    end

    subject do
      ChefSpec::SoloRunner.new(step_into: 'zap_crontab') do |node|
        allow(node).to receive(:override_runlist).and_return(%w(recipe[test::force]))
      end.converge(described_recipe)
    end

    it { is_expected.to call_zap_crontab('root') }
    it { is_expected.not_to delete_cron('obsolete') }
  end

  context 'override, force' do
    before do
      expect(Chef::Log).to receive(:warn)
        .with('Forcing zap_crontab[root] during override_runlist')
        .twice
    end

    subject do
      ChefSpec::SoloRunner.new(step_into: 'zap_crontab') do |node|
        allow(node).to receive(:override_runlist).and_return(%w(recipe[test::force]))
        node.override['force_zap_on_override'] = true
      end.converge(described_recipe)
    end

    it { is_expected.to call_zap_crontab('root') }
    it { is_expected.to delete_cron('obsolete') }
  end
end

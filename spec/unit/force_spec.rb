require 'spec_helper'

describe 'test::force' do
  before do
    root = <<EOF
# Chef Name: obsolete
* * * * * true
EOF
    allow(Mixlib::ShellOut).to receive(:new).and_call_original
    allow(Mixlib::ShellOut).to receive(:new)
      .with('crontab -l -u root')
      .and_return(double(run_command: nil, stdout: root))
  end

  context '!override, !force' do
    let :runner do
      ChefSpec::SoloRunner.new(step_into: 'zap_crontab') do |node|
        allow(node).to receive(:override_runlist).and_return([])
      end.converge(described_recipe)
    end

    it 'converges' do
      expect(runner).to call_zap_crontab('root')
      expect(runner).to delete_cron('obsolete')
    end
  end

  context '!override, force' do
    let :runner do
      ChefSpec::SoloRunner.new(step_into: 'zap_crontab') do |node|
        allow(node).to receive(:override_runlist).and_return([])
        node.override['force_zap_on_override'] = true
      end.converge(described_recipe)
    end

    it 'converges' do
      expect(runner).to call_zap_crontab('root')
      expect(runner).to delete_cron('obsolete')
    end
  end

  context 'override, !force' do
    let :runner do
      ChefSpec::SoloRunner.new(step_into: 'zap_crontab') do |node|
        allow(node).to receive(:override_runlist).and_return(%w(recipe[test::force]))
      end.converge(described_recipe)
    end

    it 'converges' do
      expect(runner).to call_zap_crontab('root')
      expect(runner).not_to delete_cron('obsolete')
    end
  end

  context 'override, force' do
    let :runner do
      ChefSpec::SoloRunner.new(step_into: 'zap_crontab') do |node|
        allow(node).to receive(:override_runlist).and_return(%w(recipe[test::force]))
        node.override['force_zap_on_override'] = true
      end.converge(described_recipe)
    end

    it 'converges' do
      expect(runner).to call_zap_crontab('root')
      expect(runner).to delete_cron('obsolete')
    end
  end
end

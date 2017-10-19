require 'spec_helper'

describe 'test::apt_repos' do
  before do
    allow(Dir).to receive(:glob).and_call_original
    allow(Dir).to receive(:glob)
      .with('/etc/apt/sources.list.d/*.list')
      .and_return(%w(/etc/apt/sources.list.d/a.list /etc/apt/sources.list.d/chef-stable.list))
  end

  subject do
    ChefSpec::SoloRunner.new(platform: 'debian', version: 7.0, step_into: 'zap') do |node|
      node.override['zap']['apt_repos']['immediately'] = false
    end.converge(described_recipe)
  end

  it { is_expected.to call_zap_remove('apt_repos') }
  it { is_expected.to     remove_apt_repository('a') }
  it { is_expected.not_to remove_apt_repository('chef-stable') }
end

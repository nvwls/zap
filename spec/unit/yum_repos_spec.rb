require 'spec_helper'

describe 'test::yum_repos' do
  before do
    allow(Dir).to receive(:glob).and_call_original
    allow(Dir).to receive(:glob)
      .with('/etc/yum.repos.d/*.repo')
      .and_return(%w(/etc/yum.repos.d/chef-stable.repo /etc/yum.repos.d/a.repo))
  end

  subject do
    ChefSpec::SoloRunner.new(step_into: 'zap') do |node|
      node.override['zap']['yum_repos']['immediately'] = false
    end.converge(described_recipe)
  end

  it { is_expected.to call_zap_delete('yum_repos') }
  it { is_expected.to     delete_yum_repository('a') }
  it { is_expected.not_to delete_yum_repository('chef-stable') }
end

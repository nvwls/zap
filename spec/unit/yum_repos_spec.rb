require 'spec_helper'

describe 'test::yum_repos' do
  before(:each) do
    allow(Dir).to receive(:glob).and_call_original
    allow(Dir).to receive(:glob)
      .with('/etc/yum.repos.d/*.repo')
      .and_return(%w(/etc/yum.repos.d/chef-stable.repo /etc/yum.repos.d/evil.repo))
  end

  let(:runner) do
    ChefSpec::SoloRunner.new(step_into: 'zap_yum_repos') do |node|
    end.converge(described_recipe)
  end

  it 'removes unmanaged repos' do
    expect(runner).to     delete_yum_repository('evil')
    expect(runner).not_to delete_yum_repository('chef-stable')
  end
end

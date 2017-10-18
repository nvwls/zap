require 'spec_helper'

describe 'test::users' do
  before(:each) do
    allow(IO).to receive(:foreach).and_call_original
    allow(IO).to receive(:foreach)
      .with('/etc/passwd')
      .and_yield('root:*:0:0::/root:/bin/bash\n')
      .and_yield('daemon:*:10:10::/var/empty:/usr/bin/false\n')
      .and_yield('larry:*:100:200::/var/empty:/usr/bin/false\n')
      .and_yield('moe:*:501:200::/var/empty:/usr/bin/false\n')
      .and_yield('curly:*:502:200::/var/empty:/usr/bin/false\n')
      .and_yield('waldo:*:503:200::/var/empty:/usr/bin/false\n')
  end

  context 'without a pattern' do
    subject do
      ChefSpec::SoloRunner.new(step_into: 'zap_users') do |node|
      end.converge(described_recipe)
    end

    it { is_expected.not_to delete_user('root') }
    it { is_expected.not_to delete_user('daemon') }
    it { is_expected.not_to delete_user('larry') }
    it { is_expected.not_to delete_user('moe') }
    it { is_expected.to     delete_user('curly') }
    it { is_expected.to     delete_user('waldo') }
  end

  context 'with a pattern' do
    subject do
      ChefSpec::SoloRunner.new(step_into: 'zap_users') do |node|
        node.normal['users']['pattern'] = '*aldo*'
      end.converge(described_recipe)
    end

    it { is_expected.not_to delete_user('root') }
    it { is_expected.not_to delete_user('daemon') }
    it { is_expected.not_to delete_user('curly') }
    it { is_expected.not_to delete_user('moe') }
    it { is_expected.not_to delete_user('larry') }
    it { is_expected.to     delete_user('waldo') }
  end
end

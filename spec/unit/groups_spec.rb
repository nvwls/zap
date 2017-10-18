require 'spec_helper'

describe 'test::groups' do
  before do
    allow(IO).to receive(:foreach).and_call_original
    allow(IO).to receive(:foreach)
      .with('/etc/group')
      .and_yield('wheel:*:0:\n')
      .and_yield('curly:*:100:\n')
      .and_yield('moe:*:501:\n')
      .and_yield('larry:*:502:\n')
      .and_yield('waldo:*:503:\n')
  end

  context 'without a pattern' do
    subject do
      ChefSpec::SoloRunner.new(step_into: 'zap_groups') do |node|
      end.converge(described_recipe)
    end

    it { is_expected.not_to remove_group('wheel') }
    it { is_expected.not_to remove_group('curly') }
    it { is_expected.not_to remove_group('moe') }
    it { is_expected.to     remove_group('larry') }
    it { is_expected.to     remove_group('waldo') }
  end

  context 'with a pattern' do
    subject do
      ChefSpec::SoloRunner.new(step_into: 'zap_groups') do |node|
        node.normal['groups']['pattern'] = '*aldo*'
      end.converge(described_recipe)
    end

    it { is_expected.not_to remove_group('wheel') }
    it { is_expected.not_to remove_group('curly') }
    it { is_expected.not_to remove_group('moe') }
    it { is_expected.not_to remove_group('larry') }
    it { is_expected.to     remove_group('waldo') }
  end
end

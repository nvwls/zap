require 'spec_helper'

describe 'test::groups' do
  before(:each) do
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
    let(:runner) do
      ChefSpec::SoloRunner.new(step_into: 'zap_groups') do |node|
      end.converge(described_recipe)
    end

    it 'remove all unknown ids higher then 500' do
      expect(runner).not_to remove_group('wheel')
      expect(runner).not_to remove_group('curly')
      expect(runner).not_to remove_group('moe')
      expect(runner).to remove_group('larry')
      expect(runner).to remove_group('waldo')
    end
  end

  context 'with a pattern' do
    let(:runner) do
      ChefSpec::SoloRunner.new(step_into: 'zap_groups') do |node|
        node.normal['groups']['pattern'] = '*aldo*'
      end.converge(described_recipe)
    end

    it 'only username matching the pattern' do
      expect(runner).not_to remove_group('wheel')
      expect(runner).not_to remove_group('curly')
      expect(runner).not_to remove_group('moe')
      expect(runner).not_to remove_group('larry')
      expect(runner).to remove_group('waldo')
    end
  end
end

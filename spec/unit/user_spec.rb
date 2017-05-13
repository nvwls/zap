require 'spec_helper'

describe 'test::users' do
  before(:each) do
    allow(IO).to receive(:foreach).and_call_original
    allow(IO).to receive(:foreach)
      .with('/etc/passwd')
      .and_yield('curly:*:100:200::/var/empty:/usr/bin/false\n')
      .and_yield('moe:*:501:200::/var/empty:/usr/bin/false\n')
      .and_yield('larry:*:502:200::/var/empty:/usr/bin/false\n')
      .and_yield('waldo:*:503:200::/var/empty:/usr/bin/false\n')
  end

  context 'without a pattern' do
    let(:runner) do
      ChefSpec::SoloRunner.new(step_into: 'zap_users') do |node|
      end.converge(described_recipe)
    end

    it 'remove all unknown ids higher then 500' do
      expect(runner).not_to remove_user('curly')
      expect(runner).not_to remove_user('moe')
      expect(runner).to remove_user('larry')
      expect(runner).to remove_user('waldo')
    end
  end

  context 'with a pattern' do
    let(:runner) do
      ChefSpec::SoloRunner.new(step_into: 'zap_users') do |node|
        node.normal['users']['pattern'] = '*aldo*'
      end.converge(described_recipe)
    end

    it 'only username matching the pattern' do
      expect(runner).not_to remove_user('curly')
      expect(runner).not_to remove_user('moe')
      expect(runner).not_to remove_user('larry')
      expect(runner).to remove_user('waldo')
    end
  end
end

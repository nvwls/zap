# encoding: UTF-8

require 'spec_helper'

describe 'test::directory' do
  before do
    allow(Dir).to receive(:entries).and_call_original
    allow(Dir).to receive(:entries)
                   .with('/etc/profile.d')
                   .and_return(%w[crap.sh lang.sh lang.csh sub])

    allow(Dir).to receive(:entries)
                   .with('/etc/profile.d/sub')
                   .and_return(%w[foo.sh foo.csh keep.sh])

    allow(File).to receive(:directory?).and_call_original
    allow(File).to receive(:directory?)
                   .with('/etc/profile.d/crap.sh')
                   .and_return(false)
    allow(File).to receive(:directory?)
                   .with('/etc/profile.d/lang.sh')
                   .and_return(false)
    allow(File).to receive(:directory?)
                   .with('/etc/profile.d/lang.csh')
                   .and_return(false)
    allow(File).to receive(:directory?)
                   .with('/etc/profile.d/sub')
                   .and_return(true)
    allow(File).to receive(:directory?)
                   .with('/etc/profile.d/sub/foo.sh')
                   .and_return(false)
    allow(File).to receive(:directory?)
                   .with('/etc/profile.d/sub/foo.csh')
                   .and_return(false)
    allow(File).to receive(:directory?)
                   .with('/etc/profile.d/sub/keep.sh')
                   .and_return(false)
  end

  context '!pattern !recurive' do
    let :runner do
      ChefSpec::SoloRunner.new(step_into: 'zap_directory') do |node|
      end.converge(described_recipe)
    end

    it 'converges' do
      expect(runner).to delete_file('/etc/profile.d/crap.sh')
      expect(runner).not_to delete_file('/etc/profile.d/lang.sh')
      expect(runner).to delete_file('/etc/profile.d/lang.csh')

      expect(runner).not_to delete_file('/etc/profile.d/sub/foo.sh')
      expect(runner).not_to delete_file('/etc/profile.d/sub/foo.csh')
      expect(runner).not_to delete_file('/etc/profile.d/sub/keep.sh')
    end
  end

  context 'pattern=*.sh !recursive' do
    let :runner do
      ChefSpec::SoloRunner.new(step_into: 'zap_directory') do |node|
        node.normal['directory']['pattern'] = '*.sh'
      end.converge(described_recipe)
    end

    it 'converges' do
      expect(runner).to delete_file('/etc/profile.d/crap.sh')
      expect(runner).not_to delete_file('/etc/profile.d/lang.sh')
      expect(runner).not_to delete_file('/etc/profile.d/lang.csh')

      expect(runner).not_to delete_file('/etc/profile.d/sub/foo.sh')
      expect(runner).not_to delete_file('/etc/profile.d/sub/foo.csh')
      expect(runner).not_to delete_file('/etc/profile.d/sub/keep.sh')
    end
  end

  context '!pattern recursive' do
    let :runner do
      ChefSpec::SoloRunner.new(step_into: 'zap_directory') do |node|
        node.normal['directory']['recursive'] = true
      end.converge(described_recipe)
    end

    it 'converges' do
      expect(runner).to delete_file('/etc/profile.d/crap.sh')
      expect(runner).not_to delete_file('/etc/profile.d/lang.sh')
      expect(runner).to delete_file('/etc/profile.d/lang.csh')

      expect(runner).to delete_file('/etc/profile.d/sub/foo.sh')
      expect(runner).to delete_file('/etc/profile.d/sub/foo.csh')
      expect(runner).not_to delete_file('/etc/profile.d/sub/keep.sh')
    end
  end

  context 'pattern=*.sh recursive' do
    let :runner do
      ChefSpec::SoloRunner.new(step_into: 'zap_directory') do |node|
        node.normal['directory']['pattern'] = '*.sh'
        node.normal['directory']['recursive'] = true
      end.converge(described_recipe)
    end

    it 'converges' do
      expect(runner).to delete_file('/etc/profile.d/crap.sh')
      expect(runner).not_to delete_file('/etc/profile.d/lang.sh')
      expect(runner).not_to delete_file('/etc/profile.d/lang.csh')

      expect(runner).to delete_file('/etc/profile.d/sub/foo.sh')
      expect(runner).not_to delete_file('/etc/profile.d/sub/foo.csh')
      expect(runner).not_to delete_file('/etc/profile.d/sub/keep.sh')
    end
  end
end

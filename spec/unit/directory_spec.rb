require 'spec_helper'

describe 'test::directory' do
  before do
    allow(Dir).to receive(:entries).and_call_original
    allow(Dir).to receive(:entries)
      .with('/etc/conf.d')
      .and_return(%w(. .. a b c link symlink file cookbook_file template dir))

    allow(File).to receive(:directory?).and_call_original
    allow(File).to receive(:directory?)
      .with('/etc/conf.d/a')
      .and_return(false)
    allow(File).to receive(:directory?)
      .with('/etc/conf.d/b')
      .and_return(false)
    allow(File).to receive(:directory?)
      .with('/etc/conf.d/c')
      .and_return(true)
    allow(File).to receive(:directory?)
      .with('/etc/conf.d/link')
      .and_return(false)
    allow(File).to receive(:directory?)
      .with('/etc/conf.d/symlink')
      .and_return(false)
    allow(File).to receive(:directory?)
      .with('/etc/conf.d/file')
      .and_return(false)
    allow(File).to receive(:directory?)
      .with('/etc/conf.d/cookbook_file')
      .and_return(false)
    allow(File).to receive(:directory?)
      .with('/etc/conf.d/template')
      .and_return(false)
    allow(File).to receive(:directory?)
      .with('/etc/conf.d/dir')
      .and_return(true)
  end

  subject do
    ChefSpec::SoloRunner.new(step_into: 'zap_directory') do |node|
    end.converge(described_recipe)
  end

  it { is_expected.to     delete_file('/etc/conf.d/a') }
  it { is_expected.to     delete_file('/etc/conf.d/a') }
  it { is_expected.not_to delete_file('/etc/conf.d/c') }
  it { is_expected.not_to delete_file('/etc/conf.d/link') }
  it { is_expected.not_to delete_file('/etc/conf.d/symlink') }
  it { is_expected.not_to delete_file('/etc/conf.d/file') }
  it { is_expected.not_to delete_file('/etc/conf.d/cookbook_file') }
  it { is_expected.not_to delete_file('/etc/conf.d/template') }
  it { is_expected.not_to delete_file('/etc/conf.d/dir') }
end

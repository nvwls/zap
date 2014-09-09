# encoding: utf-8

zap_directory '/etc/apt/sources.list.d' do
  select do |r|
    case r.class.to_s
    when 'Chef::Resource::File', 'Chef::Resource::Template'
      r.name
    when 'Chef::Resource::AptRepository'
      "/etc/apt/sources.list.d/#{r.repositoryid}.list"
    end
  end
end

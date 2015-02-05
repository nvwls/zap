# encoding: utf-8

zap_directory '/etc/yum.repos.d' do
  select do |r|
    case r.class.to_s
    when 'Chef::Resource::File', 'Chef::Resource::Template'
      r.name
    when 'Chef::Resource::YumRepository'
      "/etc/yum.repos.d/#{r.repositoryid}.repo"
    end
  end
end

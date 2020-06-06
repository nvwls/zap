# frozen_string_literal: true

zap_crontab 'root' do
  force node['force_zap_on_override']
end

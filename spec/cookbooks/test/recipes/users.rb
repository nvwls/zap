# encoding: UTF-8

`useradd larry`
`useradd moe`
`useradd -r curly`
`useradd -r test0`
`useradd -r test1`

zap_users '/etc/passwd' do
  filter do |u|
    u.uid > 500
  end
end

zap_users 'passwd' do
  pattern 'test*'
end

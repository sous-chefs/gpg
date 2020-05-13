property :name, String, default: ''

action :install do
  include_recipe 'yum-epel' if platform_family?('rhel', 'amazon')

  package %w(haveged gnupg2)

  service 'haveged' do
    supports [:status, :restart]
    action :start
  end
end

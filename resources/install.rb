property :name, String, default: ''

action :install do
  include_recipe 'yum-epel' if platform_family?('rhel', 'amazon')

  package %W(haveged #{gpg2_packages})

  service 'haveged' do
    supports [:status, :restart]
    action :start
  end
end

action_class do
  include Gpg::Helpers
end

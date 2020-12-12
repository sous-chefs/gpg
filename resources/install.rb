property :name, String, default: ''

action :install do
  include_recipe 'yum-epel' if platform_family?('rhel', 'amazon')

  gpg2_package_name = if platform?('opensuseleap')
                        'gpg2'
                      else
                        'gnupg2'
                      end

  package %W(haveged #{gpg2_package_name})

  service 'haveged' do
    supports [:status, :restart]
    action :start
  end
end

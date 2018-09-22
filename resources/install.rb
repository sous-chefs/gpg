property :name, String, default: '' # ~FC108
property :install_extra_packages, [true,false], default: true

action :install do
  include_recipe 'yum-epel' if platform_family?('rhel')
  apt_update if platform_family?('debian')

  package %w(haveged gnupg2) if new_resource.install_extra_packages

  service 'haveged' do # FIXME: (?) this will create duplicates in case other cookbooks do the same
    supports [:status, :restart]
    action :start
  end
end

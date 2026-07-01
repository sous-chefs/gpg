unified_mode true
provides :gpg_install

property :name, String, default: ''

action :install do
  yum_epel 'default' do
    only_if { platform_family?('rhel', 'amazon') }
  end

  # On Amazon Linux 2023, gnupg2-minimal conflicts with gnupg2
  # Use --allowerasing to replace it
  package gpg2_packages do
    if platform?('amazon') && node['platform_version'].to_i >= 2023
      options '--allowerasing'
    end
  end
end

action_class do
  include Gpg::Helpers
end

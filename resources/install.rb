unified_mode true

property :name, String, default: ''

action :install do
  include_recipe 'yum-epel' if platform_family?('rhel', 'amazon')

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

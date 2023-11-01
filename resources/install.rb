unified_mode true

property :name, String, default: ''

action :install do
  include_recipe 'yum-epel' if platform_family?('rhel', 'amazon')

  # As per these instructions
  # https://docs.aws.amazon.com/linux/al2023/ug/compare-with-al2.html
  execute 'dnf swap' do
    command 'dnf swap gnupg2-minimal gnupg2-full -y'
    only_if { platform_family?('amazon') }
    not_if 'rpm -q gnupg2-full'
  end

  package gpg2_packages

  service 'haveged' do
    supports [:status, :restart]
    action :start
  end
end

action_class do
  include Gpg::Helpers
end

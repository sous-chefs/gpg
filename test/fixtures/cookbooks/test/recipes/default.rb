# Master default recipe that includes all test recipes in logical order

# Disable epel-next for CentOS Stream 10 - repository doesn't exist yet
# https://github.com/sous-chefs/yum-epel/issues
if platform?('centos') && node['platform_version'].to_i >= 10
  node.default['yum']['epel-next']['managed'] = false
  node.default['yum']['epel-next']['enabled'] = false
end

apt_update

apt_package 'sudo' if platform_family?('debian')
gpg_install

# Test 1: Generate GPG keys with various options
include_recipe 'test::test_generate'

# Test 2: Export keys to files
include_recipe 'test::test_export'

# Test 3: Import keys from files and keyservers
include_recipe 'test::test_import'

# Test 4: Delete keys (both public and secret keys)
include_recipe 'test::test_delete'

gpg_install

gpg_key 'foo'

gpg_key 'bar'

user 'vagrant' # Dokken compatability

gpg_key '' do
  user 'vagrant'
  # override_default_keyring, [true,false], default: false
  # pubring_file, String
  # secring_file, String
  name_real 'vagrant'
  name_comment 'vagrant test key'
  name_email 'vagrant@sous-chefs.org'
  expire_date '20200815T145012'
  batch_config_file '/tmp/vagrant_config'
  key_type '1'
  key_length '4096'
  passphrase 'this-is-not-secure'
end

gpg_key 'export' do
  user 'vagrant'
  name_real 'vagrant'
  key_file '/tmp/vagrant.key'
  action :export
end

gpg_key 'Import Vagrant key to root keychain' do
  user 'root'
  name_real 'vagrant'
  key_file '/tmp/vagrant.key'
  action :import
end

# Dummy key for deleting
include_recipe 'test::dummy_key'

gpg_install

%w(foo bar foobar barfoo).each do |u|
  group u
  user u do
    manage_home true
    gid u
  end
end

gpg_key 'foo' do
  user 'foo'
  passphrase 'this-is-not-secure'
end

# adding bar to root
gpg_key 'bar' do
  passphrase 'this-is-not-secure'
end

gpg_key 'foobar' do
  user 'foobar'
  # override_default_keyring, [true,false], default: false
  # pubring_file, String
  # secring_file, String
  name_real 'Foo Bar'
  name_comment 'custom comment by foobar'
  name_email 'foobar@sous-chefs.org'
  expire_date '20200815T145012'
  batch_config_file '/tmp/foobar_config'
  key_type '1'
  key_length '4096'
  passphrase 'this-is-not-secure'
end

gpg_key 'export foo' do
  user 'foo'
  name_real 'foo'
  key_file '/tmp/foo.key'
  action :export
end

gpg_key 'import key foo to root keychain' do
  user 'root'
  # name_real 'foo-imported'
  key_file '/tmp/foo.key'
  action :import
end

gpg_key 'import key foo to barfoo keychain' do
  user 'barfoo'
  # name_real 'foo-imported'
  key_file '/tmp/foo.key'
  action :import
end

# Importing the specified key
gpg_key 'Import Ubuntu Key' do
  keyserver 'keyserver.ubuntu.com'
  key_fingerprint %w(409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB)
  action :import
end

# Dummy key for deleting
include_recipe 'test::dummy_key'

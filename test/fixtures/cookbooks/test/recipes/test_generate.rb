# Test key generation with various options
# Setup users for testing
%w(foo bar foobar barfoo).each do |u|
  group u
  user u do
    manage_home true
    gid u
  end
end

# Basic key generation with default options (for root user)
gpg_key 'bar' do
  passphrase 'this-is-not-secure'
end

# Basic key generation for specific user
gpg_key 'foo' do
  user 'foo'
  passphrase 'this-is-not-secure'
end

# Advanced key generation with all options specified
gpg_key 'foobar' do
  user 'foobar'
  name_real 'Foo Bar'
  name_comment 'custom comment by foobar'
  name_email 'foobar@sous-chefs.org'
  expire_date '20200815T145012'
  batch_config_file '/tmp/foobar_config'
  key_type '1'
  key_length '4096'
  passphrase 'this-is-not-secure'
end

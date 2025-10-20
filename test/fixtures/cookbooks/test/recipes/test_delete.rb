# Test deletion scenarios
# - Add key-1 and key-2
# - Delete both public and secret portions of key-2
# Generate two keys
gpg_key 'key1' do
  batch_name 'key1'
  name_real 'Test Key One'
  key_length '2048'
  expire_date '0'
  name_email 'key1@example.com'
  passphrase 'test-passphrase-1'
  pinentry_mode 'loopback'
  action :generate
end

gpg_key 'key2' do
  batch_name 'key2'
  name_real 'Test Key Two'
  key_length '2048'
  expire_date '0'
  name_email 'key2@example.com'
  passphrase 'test-passphrase-2'
  pinentry_mode 'loopback'
  action :generate
  notifies :create, 'file[key2]', :immediately
  not_if { ::File.exist?('/tmp/key2') }
end

file 'key2' do
  path '/tmp/key2'
  content 'Only create key2 once.'
  action :nothing
end

# Scenario 2: Delete both secret and public portions of key-2
# Delete secret keys first (requires fingerprint in batch mode)
gpg_key 'key2' do
  name_real 'Test Key Two'
  action :delete_secret_keys
  notifies :delete_keys, 'gpg_key[key2]', :delayed
end

gpg_key 'key2' do
  name_real 'Test Key Two'
  action :nothing
end

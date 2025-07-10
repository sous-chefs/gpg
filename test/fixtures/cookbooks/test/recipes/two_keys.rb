# Generate two keys directly in memory
gpg_install

gpg_key 'key1' do
  user 'root'
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
  user 'root'
  batch_name 'key2'
  name_real 'Test Key Two'
  key_length '2048'
  expire_date '0'
  name_email 'key2@example.com'
  passphrase 'test-passphrase-2'
  pinentry_mode 'loopback'
  action :generate
end

gpg_key 'key1' do
  user 'root'
  name_real 'Test Key One'
  key_fingerprint lazy { node.run_state['key1_fingerprint'] }
  action :delete_public_key
end

# Generate two keys directly in memory
gpg_install

gpg_key 'key1' do
  user 'root'
  batch_name 'key1'
  name_real 'Test Key One'
  key_length '2048'
  expire_date '0'
  name_email 'key1@example.com'
  action :generate
end

gpg_key 'key2' do
  user 'root'
  batch_name 'key2'
  name_real 'Test Key Two'
  key_length '2048'
  expire_date '0'
  name_email 'key2@example.com'
  action :generate
end

ruby_block 'print keys before deletion' do
  block do
    keys_output = shell_out!('sudo -u root -i gpg2 --list-keys').stdout
    puts "\nKeys in keyring before deletion:\n#{keys_output}\n"
  end
  action :run
end

gpg_key 'key1' do
  user 'root'
  name_real 'Test Key One'
  action :delete_public_key
end

ruby_block 'print keys after deletion' do
  block do
    keys_output = shell_out!('sudo -u root -i gpg2 --list-keys').stdout
    puts "\nKeys in keyring after deletion:\n#{keys_output}\n"
  end
  action :run
end

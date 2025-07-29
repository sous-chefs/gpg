# Test key export functionality
# Depends on test_generate.rb having been run first

# Export a user's key to a file
gpg_key 'export foo' do
  user 'foo'
  name_real 'foo'
  key_file '/tmp/foo.key'
  action :export
end

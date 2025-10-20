# Two Keys Testing - Verifying one key was deleted and only one remains

control 'Two Keys Scenario' do
  title 'Add two keys, delete one, verify only one remains'
  desc 'After adding two keys and deleting one, only one key should remain in the keyring'

  describe command('gpg2 --homedir /root/.gnupg --list-keys "Test Key One"') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/Test Key One/) }
  end

  describe command('gpg2 --homedir /root/.gnupg --list-keys "Test Key Two"') do
    its('exit_status') { should eq 2 }
    its('stderr') { should match(/No public key/) }
  end

  describe command('gpg2 --homedir /root/.gnupg --list-keys') do
    its('stdout') { should match(/key1@example.com/) }
    its('stdout') { should_not match(/key2@example.com/) }
  end
end

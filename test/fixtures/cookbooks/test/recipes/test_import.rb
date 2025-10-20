# Test key import from file and keyserver
# Depends on test_export.rb having been run first

# Import a key from a file to root keychain
gpg_key 'import key foo to root keychain' do
  user 'root'
  key_file '/tmp/foo.key'
  action :import
end

# Import a key from a file to a non-root user keychain
gpg_key 'import key foo to barfoo keychain' do
  user 'barfoo'
  key_file '/tmp/foo.key'
  action :import
end

# Import a key from a keyserver
gpg_key 'Import RVM Key' do
  keyserver 'keyserver.ubuntu.com'
  key_fingerprint '409B6B1796C275462A1703113804BB82D39DC0E3'
  action :import
end

# Create and import dummy key
file '/tmp/dummy.key' do
  content <<EOF
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v2.0.14 (GNU/Linux)

mQENBFr5hf8BCACzqYz7Hz0Bg1f9kba0PKTXSTEY7Tjq1HNJL36n5gURzq0487vo
ueqzRLI2LMqcnxBeHC1M4TSe+6BJHzAQZwe6n18zMVvOJCVm2ffJXc+cmKkxSYow
AmhkYCiN1gHVAZ54E+9TWPatbEnnggaa10h1hC6+nyQXED5pJrCahRjvxDjP+R5b
AgamvRsBFZG/48iHX9HdK8ytPx31fTpWKRd+2xYd0A7UOFjr1n7kD7j1vJDARvsk
P1jJKK/Nbp37cU2IzMavdE0mUi05lzE4n0HRZAquHT0mg/xRvB6cV6KRf0ekmV4A
W8hnbvdd2NcllPNhBvQnMXctpcymdEFxYoxrABEBAAG0UUNoZWYgR2VuZXJhdGVk
IERlZmF1bHQgKGR1bW15KSAoZ2VuZXJhdGVkIGJ5IENoZWYpIDxkZWZhdWx0LWNl
bnRvcy02QGV4YW1wbGUuY29tPokBOAQTAQIAIgUCWvmF/wIbLwYLCQgHAwIGFQgC
CQoLBBYCAwECHgECF4AACgkQlkcg/0cPTtukQAf/cRKkm+oFBj6iOJV5BF4eWDNq
SWl8NXgzOS+a8/WmNPat6yCtzIeLr8ihe2E7fSGFrtquPon7uJIknLVoKPR9nJn2
NbJIGX6a2mwdvO8aFYauHFovabz9IvQ20fGd/zVPWTiC0X+TPTap0oS039qpe7Jw
I4DnMK9ALc32Gc8QUDyISsPjhR6zRLcQd1opEA3ueHom9606ZMTGqJVsP8vNTefI
uu6FWzOd2gJUfkaM5affO2Sl/myb4OW5ZQWkmKEBoAgmAIw9mkiTJ936u5agBdG6
N6kKnBoIj8S5wCsG3s9TUOIHc4jXbwmwXgKh4d7f88gzBLB23xz2TVkqVczmHA==
=/FUl
-----END PGP PUBLIC KEY BLOCK-----
EOF
end

gpg_key 'import Dummy key to root keychain' do
  user 'root'
  name_real 'dummy'
  key_file '/tmp/dummy.key'
  action :import
end

gpg_key 'import Dummy key to non-root keychain' do
  user 'barfoo'
  name_real 'dummy'
  key_file '/tmp/dummy.key'
  action :import
end

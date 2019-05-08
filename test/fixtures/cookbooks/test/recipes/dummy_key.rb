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
  not_if { ::File.exist?('/tmp/guard.txt') }
end

gpg_key 'delete public Dummy key' do
  user 'root'
  name_real 'dummy'
  key_fingerprint '7877AF01696A73C4D02176F2964720FF470F4EDB'
  action :delete_public_key
  not_if { ::File.exist?('/tmp/guard.txt') }
end

# This set of actions (add then delete) will always trigger.
# For the purposes of testing we'll stick this file on disk
# so we know we've done it.
file '/tmp/guard.txt' do
  content 'I am here to stop this resource from always firing'
end

default.gpg.name.real "Alfred Pennyworth"
default.gpg.name.comment "generated by Chef"
default.gpg.name.email "pennyworth@does.not.exist"
default.gpg.expire.date "0"
default.gpg.batch_config "/tmp/gpg_batch_config"

default.gpg.key_type = "RSA"
default.gpg.key_length = "2048"

## It is recommended to use absolute paths for the keyring files, otherwise
## gpg will assume they are located in ~/.gnupg/ 
default.gpg.override_default_keyring = false
default.gpg.pubring_file = ""
default.gpg.secring_file = ""

## run gpg as the following user which will create the keyring in the user's
## $HOME/.gnupg directory (unless keyring files are overridden)
default.gpg.user = "root"
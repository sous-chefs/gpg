# GPG cookbook

Installs and configures GPG on a system

## Custom resources

This cookboks uses custom resources to control GPG2.

Install GPG2 and haveged

```ruby
gpg_install
```

Generate a GPG key for a user

```ruby
gpg_key 'foo' do
  user 'foo'
  passphrase 'this-is-not-secure'
end
```

For further detail please see the documentation for each resource

- [gpg_install](documentation/resources/install.md)
- [gpg_key](documentation/resources/key.md)

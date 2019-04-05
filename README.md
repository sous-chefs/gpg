# GPG cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/gpg.svg)](https://supermarket.chef.io/cookbooks/gpg)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/gpg/master.svg)](https://circleci.com/gh/sous-chefs/gpg)

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

For further detail please see the documentation for each resource, or the test cookbook for example usage.

- [gpg_install](documentation/resource/install.md)
- [gpg_key](documentation/resource/key.md)
- [Test Cookbook](test/fixtures/cookbooks/test/recipes)

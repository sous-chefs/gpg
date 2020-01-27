# gpg Cookbook CHANGELOG

This file is used to list changes made in each version of the gpg cookbook.

## 1.0.1 (2020-01-26)

- Use Github Actions for testing
- Fix Ubuntu platform checks in the `gpg_key` resource
- Use true/false in the resource to simplify the types

## 1.0.0 (2019-01-26)

- Adds two new resources `gpg_install` and `gpg_key`
- Use CircleCI for testing

## 0.3.0 (2018-05-08)

- Sous Chefs will now be maintaining this cookbook. For more information on Sous Chefs see <http://sous-chefs.org/>
- This cookbook now requires Chef 12 or later
- Added a chefignore file
- Added local testing with delivery local mode
- Added Code of conduct, testing, contributing, license, and changelog files
- Added `chef_version`, `source_url`, and `issues_url` to the metadata
- Added ubuntu/debian to the metadata as supported platforms
- Updated the kitchen config to use Vagrant on common platforms
- Resolved all cookstyle / foodcritic warnings

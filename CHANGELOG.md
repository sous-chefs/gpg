# gpg Cookbook CHANGELOG

This file is used to list changes made in each version of the gpg cookbook.

## Unreleased

- Add support for adding keys via --keyserver and --recv-keys
- Remove broken test for user public key
  - There doesn't seem to be a sensible way to set the home-directory or load t he keyring for the user in the test environment
- Fix installation for Amazon Linux 2023
- Fix installation on SUSE (add missing package dependencies)
-

## 2.0.11 - *2023-09-28*

## 2.0.10 - *2023-09-04*

## 2.0.9 - *2023-07-10*

## 2.0.8 - *2023-05-16*

- Fix markdown formatting in the changelog
- Standardise files with files in sous-chefs/repo-management

## 2.0.7 - *2023-05-16*

- Standardise files with files in sous-chefs/repo-management

## 2.0.6 - *2023-05-03*

- Standardise files with files in sous-chefs/repo-management

## 2.0.5 - *2023-04-01*

- Standardise files with files in sous-chefs/repo-management

## 2.0.4 - *2023-03-02*

- Standardise files with files in sous-chefs/repo-management

## 2.0.3 - *2023-02-14*

- Remove delivery folder

## 2.0.2 - *2021-08-31*

- Standardise files with files in sous-chefs/repo-management

## 2.0.1 - *2021-06-01*

- Standardise files with files in sous-chefs/repo-management

## 2.0.0 - *2021-05-07*

- Update tested platforms
- Set minimum Chef version to 15.3 for unified_mode support

## 1.3.0 - *2020-12-14*

- Added support for SUSE and OpenSUSE

## 1.2.0 (2020-08-26)

- Comment out enforce_idempotency in kitchen.dokken.yml so tests work
- Update/Remove the platforms we test against
- Fix support for pinentry_mode on Ubuntu 16.04

## 1.1.0 (2020-05-14)

- resolved cookstyle error: resources/install.rb:1:36 convention: `Layout/TrailingWhitespace`
- resolved cookstyle error: resources/install.rb:1:37 refactor: `ChefModernize/FoodcriticComments`

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

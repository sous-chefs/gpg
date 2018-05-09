name             'gpg'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Installs/Configures gpg'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.2'
chef_version     '>= 12' if respond_to?(:chef_version)

%w(ubuntu debian).each do |os|
  supports os
end
source_url 'https://github.com/sous-chefs/gpg'
issues_url 'https://github.com/sous-chefs/gpg/issues'

#
# Cookbook Name:: gpg
# Recipe:: default
#
# Copyright 2011, AJ Christensen
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

gpg_opts = ''

if node['gpg']['override_default_keyring']
  gpg_opts = "--no-default-keyring --secret-keyring #{node['gpg']['secring_file']} --keyring #{node['gpg']['pubring_file']}"
end

unless system("sudo -u #{node['gpg']['user']} -i gpg #{gpg_opts} --list-keys | grep \"#{node['gpg']['name']['real']}\"")
  package "haveged"

  service "haveged" do
    supports [:status, :restart]
    action :start
  end

  file node['gpg']['batch_config'] do
    content <<-EOS
Key-Type: #{node['gpg']['key_type']}
Key-Length: #{node['gpg']['key_length']}
Name-Real: #{node['gpg']['name']['real']}
Name-Comment: #{node['gpg']['name']['comment']}
Name-Email: #{node['gpg']['name']['email']}
Expire-Date: #{node['gpg']['expire']['date']}
EOS
  if node['gpg']['override_default_keyring']
    content << "%pubring #{node['gpg']['pubring_file']}\n"
    content << "%secring #{node['gpg']['secring_file']}\n"
  end
  content << "%commit\n"
  end

  execute "gpg: generate" do
    command "sudo -u #{node['gpg']['user']} -i gpg #{gpg_opts} --gen-key --batch #{node['gpg']['batch_config']}"
  end

  service "haveged" do
    action :stop
  end

  package "haveged" do
    action :purge
  end
end

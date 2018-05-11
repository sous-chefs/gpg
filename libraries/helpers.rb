module Gpg
  module Helpers
    include Chef::Mixin::ShellOut

    def key_exists(new_resource)
      gpg_check = "sudo -u #{new_resource.user} gpg2"
      gpg_check << gpg_opts if new_resource.override_default_keyring
      gpg_check << " --list-keys | grep '#{new_resource.name_real}'"

      cmd = Mixlib::ShellOut.new(gpg_check, user: new_resource.user)
      cmd.run_command

      cmd.exitstatus == 0
    end

    def gpg_opts(new_resource)
      if new_resource.override_default_keyring
        "--no-default-keyring --secret-keyring #{new_resource.secring_file} --keyring #{new_resource.pubring_file}"
      else
        false
      end
    end
  end
end

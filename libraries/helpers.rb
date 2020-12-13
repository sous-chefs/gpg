module Gpg
  module Helpers
    include Chef::Mixin::ShellOut

    def key_exists(new_resource)
      gpg_check = gpg_cmd
      gpg_check << gpg_opts if new_resource.override_default_keyring
      gpg_check << "--list-keys | grep '#{new_resource.name_real}'"

      cmd = Mixlib::ShellOut.new(
        gpg_check,
        user: new_resource.user,
        group: new_resource.group
      )

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

    def gpg_cmd
      "gpg2 --homedir #{new_resource.home_dir} "
    end

    def gpg2_packages
      packages = %w(haveged)
      if platform?('opensuseleap', 'suse')
        packages.push('gpg2')
      else
        packages.push('gnupg2')
      end
      packages
    end
  end
end

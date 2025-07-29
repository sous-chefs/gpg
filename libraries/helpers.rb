module Gpg
  module Helpers
    include Chef::Mixin::ShellOut

    def key_exists(new_resource, fingerprint)
      gpg_check = gpg_cmd
      gpg_check << override_command(new_resource) if new_resource.override_default_keyring

      gpg_check << if fingerprint
                     " --list-keys #{fingerprint}"
                   else
                     " --list-keys | grep '#{new_resource.name_real}'"
                   end

      cmd = Mixlib::ShellOut.new(
        gpg_check,
        user: new_resource.user,
        group: new_resource.group
      )
      cmd.run_command
      cmd.exitstatus == 0
    end

    def key_file_fingerprint(new_resource)
      gpg_show = gpg_cmd
      gpg_show << override_command(new_resource) if new_resource.override_default_keyring
      gpg_show << " --show-keys #{new_resource.key_file} | awk 'NR==2 {print $1}'"

      cmd = Mixlib::ShellOut.new(
        gpg_show,
        user: new_resource.user,
        group: new_resource.group
      )
      cmd.run_command
      cmd.stdout
    end

    # Retrieves the fingerprint for a GPG key by name
    # @param new_resource [Chef::Resource] The resource with user, group, and name_real attributes
    # @return [String, nil] The fingerprint if found, nil otherwise
    def get_fingerprint(new_resource)
      return new_resource.key_fingerprint if new_resource.key_fingerprint

      cmd_str = gpg_cmd
      cmd_str << override_command(new_resource) if new_resource.override_default_keyring
      cmd_str << " --list-keys --with-colons '#{new_resource.name_real}' | grep fpr | cut -d ':' -f 10"

      cmd = Mixlib::ShellOut.new(
        cmd_str,
        user: new_resource.user,
        group: new_resource.group
      )
      cmd.run_command

      if cmd.exitstatus == 0 && !cmd.stdout.strip.empty?
        fingerprint = cmd.stdout.strip
        Chef::Log.info("Found fingerprint for #{new_resource.name_real}: #{fingerprint}")
        fingerprint
      else
        Chef::Log.warn("Failed to retrieve fingerprint for #{new_resource.name_real}")
        nil
      end
    end

    def override_command(new_resource)
      "--no-default-keyring --secret-keyring #{new_resource.secring_file} --keyring #{new_resource.pubring_file}"
    end

    # Ensure GPG uses the correct home directory for the current resource
    def gpg_cmd
      "gpg2 --homedir #{new_resource.home_dir} "
    end

    def gpg2_packages
      case node['platform_family']
      when 'suse'
        %w(haveged gpg2)
      when 'amazon'
        if node['platform_version'].to_i >= 2023
          %w(haveged)
        else
          %w(haveged gnupg2)
        end
      else
        %w(haveged gnupg2)
      end
    end
  end
end

# package
# gnupg2-minimal-2.3.7-1.amzn2023.0.4.aarch64 conflicts with
# gnupg2 provided by
# gnupg2-2.3.7-1.amzn2023.0.4.aarch64

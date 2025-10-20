require 'shellwords'

module Gpg
  module Helpers
    include Chef::Mixin::ShellOut

    # Execute a GPG command with proper user and group context
    # @param command [String] The command to execute
    # @param new_resource [Chef::Resource] The resource with user and group attributes
    # @return [Mixlib::ShellOut] The executed command object
    def run_gpg_command(command, new_resource)
      cmd = Mixlib::ShellOut.new(
        command,
        user: new_resource.user,
        group: new_resource.group
      )
      cmd.run_command

      # GPG 2.4+ keyboxd holds locks - release them after each command
      unlock_keyboxd(new_resource) if uses_keyboxd?

      cmd
    end

    # Check if GPG 2.4+ with keyboxd is in use
    # GPG 2.4.0+ introduced keyboxd as the default keyring manager
    # https://dev.gnupg.org/T6838
    def uses_keyboxd?
      return @uses_keyboxd unless @uses_keyboxd.nil?

      version_cmd = Mixlib::ShellOut.new('gpg2 --version')
      version_cmd.run_command

      if version_cmd.exitstatus == 0
        # Parse version from output like "gpg (GnuPG) 2.4.7"
        version_match = version_cmd.stdout.match(/gpg \(GnuPG\) (\d+)\.(\d+)\.(\d+)/)
        if version_match
          major = version_match[1].to_i
          minor = version_match[2].to_i

          # GPG 2.4.0+ uses keyboxd by default
          @uses_keyboxd = (major > 2 || (major == 2 && minor >= 4))
          Chef::Log.debug("GPG version #{major}.#{minor} detected, keyboxd: #{@uses_keyboxd}")
          return @uses_keyboxd
        end
      end

      # Default to false if we can't determine version
      @uses_keyboxd = false
    rescue StandardError => e
      Chef::Log.debug("Failed to detect GPG version: #{e.message}")
      @uses_keyboxd = false
    end

    # Unlock keyboxd database for the current resource's home directory
    # GPG 2.4+ uses keyboxd which holds locks on public-keys.d/pubring.db
    # https://dev.gnupg.org/T6838
    def unlock_keyboxd(new_resource)
      home_dir = new_resource.home_dir
      return unless ::Dir.exist?(home_dir)

      # Check if public-keys.d exists (keyboxd creates this directory)
      pubkeys_dir = ::File.join(home_dir, 'public-keys.d')
      return unless ::Dir.exist?(pubkeys_dir)

      # Use gpgconf to unlock the database file (relative path from GNUPGHOME)
      unlock_cmd = Mixlib::ShellOut.new(
        'gpgconf --unlock public-keys.d/pubring.db',
        user: new_resource.user,
        group: new_resource.group,
        environment: { 'GNUPGHOME' => home_dir }
      )
      unlock_cmd.run_command
      # Ignore errors - lock may not exist
    rescue StandardError => e
      Chef::Log.debug("Failed to unlock keyboxd for #{home_dir}: #{e.message}")
    end

    def key_exists(new_resource, fingerprint)
      gpg_check = gpg_cmd
      gpg_check << override_command(new_resource) if new_resource.override_default_keyring

      gpg_check << if fingerprint
                     " --list-keys #{Shellwords.escape(fingerprint)}"
                   else
                     " --list-keys | grep #{Shellwords.escape(new_resource.name_real)}"
                   end

      cmd = run_gpg_command(gpg_check, new_resource)
      cmd.exitstatus == 0
    end

    def key_file_fingerprint(new_resource)
      gpg_show = gpg_cmd
      gpg_show << override_command(new_resource) if new_resource.override_default_keyring
      gpg_show << " --show-keys #{Shellwords.escape(new_resource.key_file)} | awk 'NR==2 {print $1}'"

      cmd = run_gpg_command(gpg_show, new_resource)
      cmd.stdout.strip
    end

    # Retrieves the fingerprint for a GPG key by name
    # @param new_resource [Chef::Resource] The resource with user, group, and name_real attributes
    # @return [String, nil] The fingerprint if found, nil otherwise
    def get_fingerprint(new_resource)
      return new_resource.key_fingerprint if new_resource.key_fingerprint

      cmd_str = gpg_cmd
      cmd_str << override_command(new_resource) if new_resource.override_default_keyring
      cmd_str << " --list-keys --with-colons #{Shellwords.escape(new_resource.name_real)} | grep fpr | cut -d ':' -f 10"

      # Retry logic for GPG 2.4+ keyboxd - database may need a moment to sync
      retries = 3
      retries.times do |attempt|
        cmd = run_gpg_command(cmd_str, new_resource)

        if cmd.exitstatus == 0 && !cmd.stdout.strip.empty?
          fingerprint = cmd.stdout.strip
          Chef::Log.info("Found fingerprint for #{new_resource.name_real}: #{fingerprint}")
          return fingerprint
        end

        # Wait before retry (except on last attempt)
        sleep 1 if attempt < retries - 1
      end

      Chef::Log.warn("Failed to retrieve fingerprint for #{new_resource.name_real}")
      nil
    end

    def override_command(new_resource)
      "--no-default-keyring --secret-keyring #{Shellwords.escape(new_resource.secring_file)} --keyring #{Shellwords.escape(new_resource.pubring_file)}"
    end

    # Ensure GPG uses the correct home directory for the current resource
    def gpg_cmd
      "gpg2 --homedir #{Shellwords.escape(new_resource.home_dir)} "
    end

    def gpg2_packages
      if platform_family?('suse')
        %w(gpg2)
      else
        %w(gnupg2)
      end
    end
  end
end

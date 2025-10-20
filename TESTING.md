# Testing

Please refer to [the community cookbook documentation on testing](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/main/TESTING.MD).

## Quick Start for Local Testing

### Prerequisites

- **Chef Workstation**: Install from [Chef Downloads](https://www.chef.io/downloads/tools/workstation)
- **Docker**: Required for Dokken driver (faster local testing)
  - macOS: [Docker Desktop](https://www.docker.com/products/docker-desktop)
  - Linux: Install via package manager

### Setup

1. **Enable Dokken driver** (faster than Vagrant):

   ```bash
   export KITCHEN_LOCAL_YAML=kitchen.dokken.yml
   ```

   Or add to your shell profile (`~/.bashrc`, `~/.zshrc`, or use `mise.toml`):

   ```bash
   echo 'export KITCHEN_LOCAL_YAML=kitchen.dokken.yml' >> ~/.zshrc
   ```

2. **Verify setup**:

   ```bash
   kitchen list
   ```

   You should see Dokken as the driver for all instances.

### Running Tests

#### Run a single platform

```bash
kitchen test default-almalinux-9
```

#### Run all platforms

```bash
kitchen test
```

#### Run specific platforms for verification

```bash
kitchen test default-debian-12 default-ubuntu-2204 default-rockylinux-9
```

#### Debug a failing test

```bash
# Create and converge the instance
kitchen converge default-almalinux-9

# Login to inspect
kitchen login default-almalinux-9

# Inside the container, check GPG installation and keys
sudo -u root -i gpg2 --list-keys
sudo -u foo -i gpg2 --list-keys
ls -la /root/.gnupg
ls -la /home/foo/.gnupg

# Run tests manually
kitchen verify default-almalinux-9

# Cleanup when done
kitchen destroy default-almalinux-9
```

### Troubleshooting

#### Docker permission errors

```bash
# Linux: Add your user to docker group
sudo usermod -aG docker $USER
# Then logout and login again
```

#### Kitchen hangs or fails to start

```bash
# Clean up old containers
docker ps -a | grep kitchen | awk '{print $1}' | xargs docker rm -f

# Clean up dokken network
docker network prune
```

#### Tests pass locally but fail in CI

- Check platform-specific package names and paths
- Verify haveged service is running properly
- Review CI logs for specific error messages
- Check GPG version compatibility

### Test Suite Overview

The **default** suite tests:

- **GPG Installation**: Installs gpg2 and haveged packages
- **Key Generation**: Creates keys for root and various users with different options
- **Key Export**: Exports generated keys to files
- **Key Import**: Imports keys from files and keyservers
- **Key Deletion**: Deletes both secret and public key portions

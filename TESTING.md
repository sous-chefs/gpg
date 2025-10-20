# Testing

This cookbook follows [Chef community cookbook testing standards](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/main/TESTING.MD).

## Testing Overview

This cookbook uses:

- **Unit Testing**: [ChefSpec](http://sethvargo.github.io/chefspec/) for in-memory cookbook logic testing
- **Integration Testing**: Test Kitchen with InSpec for platform-specific validation

## Unit Testing

Unit tests use [ChefSpec](http://sethvargo.github.io/chefspec/) to verify cookbook logic without converging. Unit tests are located in `spec/unit/` and compile the cookbook in-memory to test complex logic quickly.

## Integration Testing

### Prerequisites

- **Chef Workstation**: Install from [Chef Downloads](https://www.chef.io/downloads/tools/workstation)
- **Docker**: Required for Dokken driver (faster local testing)
  - macOS: [Docker Desktop](https://www.docker.com/products/docker-desktop)
  - Linux: Install via package manager
- **Vagrant & VirtualBox**: Alternative to Docker for integration testing
  - [Vagrant](https://www.vagrantup.com/downloads.html)
  - [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

### Quick Start

#### Option 1: Docker with Dokken (Recommended - Faster)

1. **Enable Dokken driver**:

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

#### Option 2: Vagrant with VirtualBox

Use the default `kitchen.yml` configuration:

```bash
kitchen list
```

### Running Integration Tests

#### Run all platforms

```bash
kitchen test
```

#### Run a single platform

```bash
kitchen test default-almalinux-9
```

#### Run specific platforms

```bash
kitchen test default-almalinux-9 default-ubuntu-2004
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

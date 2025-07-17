# PDS System Shell Scripts

This directory contains utility shell scripts for the PDS (Personal Data Store) microservices system.

## Available Scripts

- **setup_hosts.sh** - Configures local host entries for domain emulation
  ```
  sudo ./shell/setup_hosts.sh
  ```

- **setup_nginx.sh** - Sets up nginx configuration for did:web endpoints
  ```
  ./shell/setup_nginx.sh
  ```

- **generate-certs.sh** - Generates self-signed certificates for HTTPS
  ```
  ./shell/generate-certs.sh
  ```

- **copy_standards.sh** - Copies standardization documents to each service directory
  ```
  ./shell/copy_standards.sh
  ```

- **cleanup-services.sh** - Cleans up services (removes data directories, etc.)
  ```
  ./shell/cleanup-services.sh
  ```

- **cleanup_repository.sh** - Performs repository cleanup operations
  ```
  ./shell/cleanup_repository.sh
  ```

- **setup_submodules.sh** - Sets up git submodules for the repository
  ```
  ./shell/setup_submodules.sh
  ```

## Usage

These scripts should be run from the parent directory:

```bash
# From the PDS parent directory
sudo ./shell/setup_hosts.sh
./shell/setup_nginx.sh
./shell/generate-certs.sh
```

The setup_hosts.sh and setup_nginx.sh scripts should be run before starting the services with `docker-compose up -d`.

## Security Note

Some of these scripts require root/sudo privileges to modify system files (like /etc/hosts). Always review scripts that require elevated privileges before running them.

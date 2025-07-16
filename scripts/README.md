# PDS System Scripts

This directory contains utility scripts for the PDS (Personal Data Store) microservices system.

## Available Scripts

- **setup_hosts.sh** - Configures local host entries for domain emulation
  ```
  sudo ./scripts/setup_hosts.sh
  ```

- **setup_nginx.sh** - Sets up nginx configuration for did:web endpoints
  ```
  ./scripts/setup_nginx.sh
  ```

## Usage

These scripts should be run from the parent directory:

```bash
# From the PDS parent directory
sudo ./scripts/setup_hosts.sh
./scripts/setup_nginx.sh
```

Both scripts should be run before starting the services with `docker-compose up -d`.

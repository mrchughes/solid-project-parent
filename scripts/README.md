# PDS System Scripts Directory

This directory previously contained utility scripts for the PDS microservices system.

## Note: Scripts Have Moved

All shell scripts have been moved to the `/shell` directory for better organization.

Please refer to the [Shell Scripts README](/shell/README.md) for the complete list of available scripts and their usage.

## Usage

All scripts should now be run from the `/shell` directory:

```bash
# From the PDS parent directory
sudo ./shell/setup_hosts.sh
./shell/setup_nginx.sh
```

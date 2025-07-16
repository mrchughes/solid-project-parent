#!/bin/bash
# Script to update /etc/hosts for PDS domain emulation

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo"
  exit 1
fi

echo "Updating /etc/hosts for PDS domain emulation..."

# Check if entries already exist
if grep -q "pds.local" /etc/hosts && \
   grep -q "dro.gov.uk.local" /etc/hosts && \
   grep -q "fep.gov.uk.local" /etc/hosts && \
   grep -q "verifier.gov.uk.local" /etc/hosts; then
  echo "Host entries already exist."
else
  # Add the entries
  echo "" >> /etc/hosts
  echo "# PDS domain emulation" >> /etc/hosts
  echo "127.0.0.1  pds.local" >> /etc/hosts
  echo "127.0.0.1  dro.gov.uk.local" >> /etc/hosts
  echo "127.0.0.1  fep.gov.uk.local" >> /etc/hosts
  echo "127.0.0.1  verifier.gov.uk.local" >> /etc/hosts
  echo "127.0.0.1  api-registry.local" >> /etc/hosts
  
  echo "Host entries added successfully."
fi

echo "Done."

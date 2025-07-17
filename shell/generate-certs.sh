#!/bin/bash

# Script to generate self-signed certificates for local development

# Create directories if they don't exist
mkdir -p ./nginx/certs

# Generate certificates for each domain
generate_cert() {
    local domain=$1
    echo "Generating certificate for $domain..."
    
    # Generate private key
    openssl genrsa -out ./nginx/certs/$domain.key 2048
    
    # Generate CSR
    openssl req -new -key ./nginx/certs/$domain.key -out ./nginx/certs/$domain.csr -subj "/CN=$domain/O=PDS Local Development/C=GB"
    
    # Generate self-signed certificate
    openssl x509 -req -days 365 -in ./nginx/certs/$domain.csr -signkey ./nginx/certs/$domain.key -out ./nginx/certs/$domain.crt
    
    # Clean up CSR
    rm ./nginx/certs/$domain.csr
    
    echo "Certificate for $domain generated successfully"
}

# Generate certificates for each domain
generate_cert "pds.local"
generate_cert "dro.gov.uk.local"
generate_cert "fep.gov.uk.local"

# Create nginx configuration directory
mkdir -p ./nginx/conf

# Create nginx configuration file
cat > ./nginx/conf/default.conf << 'EOF'
# Default HTTP server to redirect to HTTPS
server {
    listen 80;
    server_name pds.local dro.gov.uk.local fep.gov.uk.local;
    
    # Redirect all HTTP requests to HTTPS
    return 301 https://$host$request_uri;
}

# HTTPS server for pds.local
server {
    listen 443 ssl;
    server_name pds.local;
    
    ssl_certificate /etc/nginx/certs/pds.local.crt;
    ssl_certificate_key /etc/nginx/certs/pds.local.key;
    
    location / {
        proxy_pass http://solid-pds:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# HTTPS server for dro.gov.uk.local
server {
    listen 443 ssl;
    server_name dro.gov.uk.local;
    
    ssl_certificate /etc/nginx/certs/dro.gov.uk.local.crt;
    ssl_certificate_key /etc/nginx/certs/dro.gov.uk.local.key;
    
    location / {
        proxy_pass http://DRO:3002;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# HTTPS server for fep.gov.uk.local
server {
    listen 443 ssl;
    server_name fep.gov.uk.local;
    
    ssl_certificate /etc/nginx/certs/fep.gov.uk.local.crt;
    ssl_certificate_key /etc/nginx/certs/fep.gov.uk.local.key;
    
    location / {
        proxy_pass http://FEP:3003;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

echo "Nginx configuration created successfully"
echo "Please add the following entries to your /etc/hosts file:"
echo "127.0.0.1  pds.local"
echo "127.0.0.1  dro.gov.uk.local"
echo "127.0.0.1  fep.gov.uk.local"

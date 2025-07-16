#!/bin/bash
# Script to update nginx configurations for did:web endpoints

# Create nginx config directory if it doesn't exist
mkdir -p ./nginx/conf

# Create the nginx configuration for domain routing
cat > ./nginx/conf/default.conf << 'EOF'
# Default server configuration
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    
    # Default route to API Registry documentation
    location / {
        proxy_pass http://api-registry:3005/docs;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

# DRO domain
server {
    listen 80;
    server_name dro.gov.uk.local;
    
    # Route to DRO service
    location / {
        proxy_pass http://DRO:3002;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    # Ensure .well-known/did.json is accessible
    location /.well-known/did.json {
        proxy_pass http://DRO:3002/.well-known/did.json;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        add_header Access-Control-Allow-Origin *;
    }
}

# Benefits App domain
server {
    listen 80;
    server_name benefits.gov.uk.local;
    
    # Route to FEP App
    location / {
        proxy_pass http://FEP:3003;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    # Ensure .well-known/did.json is accessible
    location /.well-known/did.json {
        proxy_pass http://FEP:3003/.well-known/did.json;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        add_header Access-Control-Allow-Origin *;
    }
}

# VC Verifier domain
server {
    listen 80;
    server_name verifier.gov.uk.local;
    
    # Route to VC Verifier
    location / {
        proxy_pass http://vc-verifier:3004;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    # Ensure .well-known/did.json is accessible
    location /.well-known/did.json {
        proxy_pass http://vc-verifier:3004/.well-known/did.json;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        add_header Access-Control-Allow-Origin *;
    }
}

# PDS domain
server {
    listen 80;
    server_name pds.local;
    
    # Route to Solid PDS
    location / {
        proxy_pass http://solid-pds:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

# API Registry domain
server {
    listen 80;
    server_name api-registry.local;
    
    # Route to API Registry
    location / {
        proxy_pass http://api-registry:3005;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
EOF

echo "Nginx configuration updated for did:web endpoints"

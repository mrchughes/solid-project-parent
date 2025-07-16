# Architecture Update Summary

## Overview of Changes

We have updated the PDS architecture to remove the central DID Registry service in favor of a distributed approach using the `did:web` method. This simplifies the architecture while maintaining all required functionality.

## Changes Made

1. **docker-compose.yml**
   - Removed the DID Registry service
   - Updated service dependencies to remove references to the DID Registry
   - Updated environment variables for direct did:web resolution

2. **UPDATED_ARCHITECTURE.md**
   - Created a comprehensive document explaining the updated architecture
   - Detailed the distributed did:web implementation approach
   - Outlined the changes required for each service

3. **MERN App docker-compose.yml**
   - Removed DID_REGISTRY_URL environment variable
   - Added APP_DOMAIN environment variable for did:web resolution

## Required Implementation Steps

To complete the implementation of this updated architecture, the following steps are required:

### For the Test VC Creator (DRO)

1. Implement a `/.well-known/did.json` endpoint that serves a valid DID document
2. Update credential signing to use the local keypair instead of relying on the DID Registry
3. Update credential verification to resolve DIDs directly from their source domains
4. Remove any code that interacts with the DID Registry

### For the VC Verifier

1. Implement a `/.well-known/did.json` endpoint if needed
2. Update credential verification to resolve DIDs directly from their source domains
3. Remove any code that interacts with the DID Registry

### For the MERN App

1. Implement a `/.well-known/did.json` endpoint if needed
2. Update to use the VC Verifier service for credential verification
3. Remove any code that interacts with the DID Registry

### For the Nginx Configuration

1. Update to ensure proper routing for the `/.well-known/did.json` endpoints on each domain:
   - dro.gov.uk.local
   - benefits.gov.uk.local
   - verifier.gov.uk.local

## Testing the Updated Architecture

To verify that the updated architecture works correctly, test the following flows:

1. DRO issuing credentials with its did:web identity
2. VC Verifier resolving the DRO's DID and verifying credentials
3. MERN App connecting to the VC Verifier for credential verification
4. End-to-end flow from credential issuance to verification in the benefits application

## UI Requirements

Remember that all services must have GOV.UK style guide compliant UIs and be fully functional without any placeholders.

## Next Steps

1. Implement the required changes in each service
2. Update unit and integration tests to reflect the new architecture
3. Update documentation to explain the distributed did:web approach
4. Test all flows to ensure functionality is maintained

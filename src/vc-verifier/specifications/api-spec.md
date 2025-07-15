# VC Verifier Service Specification

## Overview

The VC Verifier Service is responsible for verifying Verifiable Credentials (VCs) retrieved from a user's Solid Pod. It verifies the authenticity and integrity of VCs by resolving the issuer's DID, validating the signature, and checking the credential's status.

## Features

- **Credential Verification**: Verify the authenticity and integrity of VCs
- **DID Resolution**: Resolve DIDs to verify the issuer's identity
- **Signature Validation**: Validate the cryptographic signatures on VCs
- **Credential Status Checking**: Check if a credential has been revoked or suspended
- **Data Extraction**: Extract verified claims from VCs

## API Endpoints

### Verification Operations

- `POST /verify` - Verify a Verifiable Credential
  - Request body:
    ```json
    {
      "verifiableCredential": {
        // VC object
      }
    }
    ```
  - Response: `200 OK` with verification result
    ```json
    {
      "verified": true,
      "results": {
        "signature": true,
        "status": true,
        "expiration": true
      },
      "claims": {
        // Extracted claims
      }
    }
    ```

- `POST /verify-from-pod` - Retrieve and verify a VC from a Solid Pod
  - Request body:
    ```json
    {
      "podUrl": "https://example.org/alice/",
      "vcPath": "profile/credentials/personal-info.json"
    }
    ```
  - Response: `200 OK` with verification result (same format as above)

### Batch Operations

- `POST /verify-batch` - Verify multiple VCs
  - Request body:
    ```json
    {
      "verifiableCredentials": [
        // Array of VC objects
      ]
    }
    ```
  - Response: `200 OK` with verification results for each VC

## Implementation Details

The VC Verifier Service is implemented as a Node.js application using Express.js. It uses libraries such as `did-jwt-vc` or `@digitalbazaar/vc-js` to verify VCs, and `@inrupt/solid-client` to interact with Solid Pods.

### Verification Process

The verification process involves several steps:

1. Parse the VC and extract the issuer's DID
2. Resolve the issuer's DID to retrieve the DID Document
3. Extract the relevant verification method from the DID Document
4. Verify the signature using the verification method
5. Check the credential's status and expiration
6. Extract and return the verified claims

## Deployment

The VC Verifier Service is deployed as a Docker container. It exposes the API on port 3003 and communicates with the DID Registry and Solid PDS services.

## Dependencies

- Node.js
- Express.js
- did-jwt-vc or @digitalbazaar/vc-js
- @inrupt/solid-client

## Integration Points

The VC Verifier Service interacts with the following services:

- **DID Registry Service**: Resolves DIDs to verify the issuer's identity
- **Solid PDS**: Retrieves VCs from the user's pod
- **MERN App**: Provides verification services to the MERN application
- **React UI**: Provides verification services to the React UI

# DID Registry Service Specification

## Overview

The DID Registry Service provides functionality to register, retrieve, update, and deactivate Decentralized Identifiers (DIDs) and their associated DID Documents. It serves as a central registry for DIDs used by various services in the system, supporting the verification of Verifiable Credentials.

## Features

- **DID Registration**: Create and register new DIDs and their associated DID Documents
- **DID Resolution**: Resolve DIDs to retrieve their DID Documents
- **DID Document Management**: Update and deactivate DIDs and their associated DID Documents
- **DID Method Support**: Support for multiple DID methods, including `did:web` and `did:key`
- **Verification**: Support for verifying DIDs and their proofs

## API Endpoints

### DID Management

- `POST /dids` - Register a new DID and its DID Document
  - Request body: `{ "didDocument": {...} }`
  - Response: `201 Created` with the registered DID Document

- `GET /dids/:did` - Retrieve a DID Document for a specific DID
  - Response: `200 OK` with the DID Document
  - Response: `404 Not Found` if the DID does not exist

- `PUT /dids/:did` - Update a DID Document
  - Request body: `{ "didDocument": {...} }`
  - Response: `200 OK` with the updated DID Document
  - Response: `404 Not Found` if the DID does not exist

- `DELETE /dids/:did` - Deactivate a DID
  - Response: `204 No Content`
  - Response: `404 Not Found` if the DID does not exist

### Query Operations

- `GET /dids` - List all registered DIDs
  - Query parameters:
    - `method`: Filter by DID method
    - `controller`: Filter by DID controller
  - Response: `200 OK` with an array of DIDs

## Implementation Details

The DID Registry Service is implemented as a Node.js application using Express.js. It stores DID Documents in a local JSON database using LowDB or similar lightweight database.

### DID Document Structure

A DID Document follows the W3C DID Core specification and includes:

```json
{
  "@context": ["https://www.w3.org/ns/did/v1"],
  "id": "did:example:123456789abcdefghi",
  "verificationMethod": [{
    "id": "did:example:123456789abcdefghi#keys-1",
    "type": "Ed25519VerificationKey2020",
    "controller": "did:example:123456789abcdefghi",
    "publicKeyMultibase": "z6MkhaXgBZDvotDkL5257faiztiGiC2QtKLGpbnnEGta2doK"
  }],
  "authentication": [
    "did:example:123456789abcdefghi#keys-1"
  ]
}
```

## Deployment

The DID Registry Service is deployed as a Docker container. It exposes the API on port 3001 and stores data in a volume.

## Dependencies

- Node.js
- Express.js
- LowDB or similar JSON database
- did-resolver and associated DID method libraries

## Integration Points

The DID Registry Service interacts with the following services:

- **Test VC Creator Service**: The VC Creator uses the DID Registry to register and retrieve DIDs for signing credentials
- **VC Verifier Service**: The VC Verifier uses the DID Registry to resolve DIDs for verifying credentials

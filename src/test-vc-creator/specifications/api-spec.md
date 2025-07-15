# Test VC Creator Service Specification

## Overview

The Test VC Creator Service generates mock Verifiable Credentials (VCs) for testing purposes. It creates signed credentials that mimic those that would be issued by government departments or other trusted authorities. These credentials include personal information such as name, address, date of birth, and benefit awards.

## Features

- **Credential Generation**: Create mock VCs with configurable claims
- **DID-based Signing**: Sign VCs using DIDs registered in the DID Registry
- **Solid Pod Integration**: Store VCs in the user's Solid Pod
- **Credential Types**: Support for multiple credential types (personal info, benefits, etc.)

## API Endpoints

### Credential Management

- `POST /issue-test-vc` - Generate and sign a test VC
  - Request body:
    ```json
    {
      "podUrl": "https://example.org/alice/",
      "credentialType": "PersonalInfoCredential",
      "claims": {
        "name": "Alice Smith",
        "address": "123 Main St, Anytown, AT 12345",
        "dateOfBirth": "1990-01-01"
      }
    }
    ```
  - Response: `201 Created` with the generated VC

- `POST /issue-benefit-vc` - Generate and sign a benefit award VC
  - Request body:
    ```json
    {
      "podUrl": "https://example.org/alice/",
      "credentialType": "BenefitAwardCredential",
      "claims": {
        "benefitType": "Housing Benefit",
        "awardAmount": "£1000",
        "awardDate": "2023-01-01",
        "awardDuration": "12 months"
      }
    }
    ```
  - Response: `201 Created` with the generated VC

### DID Management

- `GET /did` - Retrieve the service's DID used for signing
  - Response: `200 OK` with the DID

## Implementation Details

The Test VC Creator Service is implemented as a Node.js application using Express.js. It uses libraries such as `did-jwt-vc` or `@digitalbazaar/vc-js` to issue and sign VCs, and `@inrupt/solid-client` to interact with Solid Pods.

### Verifiable Credential Structure

Verifiable Credentials follow the W3C VC Data Model and include:

```json
{
  "@context": [
    "https://www.w3.org/2018/credentials/v1",
    "https://www.w3.org/2018/credentials/examples/v1"
  ],
  "id": "http://example.gov/credentials/3732",
  "type": ["VerifiableCredential", "PersonalInfoCredential"],
  "issuer": "did:example:123456789abcdefghi",
  "issuanceDate": "2023-01-01T19:23:24Z",
  "credentialSubject": {
    "id": "did:example:subject",
    "name": "Alice Smith",
    "address": "123 Main St, Anytown, AT 12345",
    "dateOfBirth": "1990-01-01"
  },
  "proof": {
    "type": "Ed25519Signature2020",
    "created": "2023-01-01T19:23:24Z",
    "verificationMethod": "did:example:123456789abcdefghi#keys-1",
    "proofPurpose": "assertionMethod",
    "proofValue": "z6MkhaXgBZDvotDkL5257faiztiGiC2QtKLGpbnnEGta2doK"
  }
}
```

## Deployment

The Test VC Creator Service is deployed as a Docker container. It exposes the API on port 3002 and communicates with the DID Registry and Solid PDS services.

## Dependencies

- Node.js
- Express.js
- did-jwt-vc or @digitalbazaar/vc-js
- @inrupt/solid-client

## Integration Points

The Test VC Creator Service interacts with the following services:

- **DID Registry Service**: Retrieves and registers DIDs for signing credentials
- **Solid PDS**: Stores generated VCs in the user's pod
- **React UI**: Provides a UI for users to request and view test VCs

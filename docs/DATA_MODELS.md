# PDS Microservices Data Models

This document provides a comprehensive overview of the data models used across all services in the PDS microservices ecosystem. These models ensure consistency and interoperability between services.

## Common Data Types

### Identifiers

All services should use consistent identifier formats:

- **UUID**: Use UUIDv4 for internal resource identifiers
- **DID**: Use `did:web` method for decentralized identifiers
- **URI**: Use properly formatted URIs for external references

### Timestamps

All timestamps must be:
- Stored in UTC
- Formatted as ISO 8601 strings (`YYYY-MM-DDTHH:mm:ss.sssZ`)
- Include millisecond precision

## Service-Specific Data Models

### API Registry

#### API Specification

```typescript
interface ApiSpecification {
  id: string;                 // UUID
  serviceName: string;        // Name of the service
  version: string;            // Semantic version (e.g., "1.0.0")
  specType: string;           // "OpenAPI" | "AsyncAPI" | "GraphQL" | "Custom"
  specVersion: string;        // Specification version (e.g., "3.0.0" for OpenAPI)
  content: object;            // The actual specification content
  endpoints: EndpointInfo[];  // Array of endpoint summaries
  createdAt: string;          // ISO timestamp
  updatedAt: string;          // ISO timestamp
}

interface EndpointInfo {
  path: string;               // Endpoint path
  method: string;             // HTTP method
  summary: string;            // Short description
  requiresAuth: boolean;      // Whether authentication is required
}
```

#### API Key

```typescript
interface ApiKey {
  id: string;                 // UUID
  key: string;                // Hashed API key
  serviceName: string;        // Name of the service the key belongs to
  description: string;        // Description of the key's purpose
  permissions: string[];      // Array of permission strings
  createdAt: string;          // ISO timestamp
  rotatedAt?: string;         // ISO timestamp of last rotation
  expiresAt: string;          // ISO timestamp
  lastUsedAt?: string;        // ISO timestamp
  isActive: boolean;          // Whether the key is active
}
```

### Solid PDS

The Solid PDS follows the Solid Protocol specification for data models:

#### WebID Profile

```typescript
interface WebIdProfile {
  "@context": string[];       // JSON-LD context
  "@id": string;              // WebID URI
  type: string;               // "Person" or other types
  name?: string;              // Person's name
  inbox?: string;             // Inbox location URI
  storage?: string;           // Storage location URI
  publicKey?: PublicKey;      // Public key information
  // Additional profile information
}

interface PublicKey {
  "@id": string;              // Key identifier
  "@type": string;            // Key type
  owner: string;              // WebID of the key owner
  publicKeyPem?: string;      // PEM-encoded public key
  publicKeyJwk?: object;      // JWK-encoded public key
}
```

### DRO (Departmental Records Office)

#### Verifiable Credential

```typescript
interface VerifiableCredential {
  "@context": string[];       // JSON-LD contexts
  id: string;                 // Credential identifier URI
  type: string[];             // Credential types
  issuer: string;             // Issuer DID or URI
  issuanceDate: string;       // ISO timestamp
  expirationDate?: string;    // ISO timestamp
  credentialSubject: {
    id: string;               // Subject DID or URI
    [key: string]: any;       // Credential-specific properties
  };
  proof: {
    type: string;             // Proof type
    created: string;          // ISO timestamp
    verificationMethod: string; // Method URI
    proofPurpose: string;     // Purpose
    proofValue: string;       // The actual proof value
  };
}
```

#### Credential Template

```typescript
interface CredentialTemplate {
  id: string;                 // UUID
  name: string;               // Template name
  description: string;        // Template description
  version: string;            // Template version
  type: string[];             // Credential types to include
  context: string[];          // JSON-LD contexts to include
  subjectSchema: object;      // JSON Schema for credential subject
  validityPeriod: number;     // Default validity in days
  createdAt: string;          // ISO timestamp
  updatedAt: string;          // ISO timestamp
}
```

### VC Verifier

#### Verification Request

```typescript
interface VerificationRequest {
  id: string;                 // UUID
  credential: object;         // The credential to verify
  options?: {
    checks?: string[];        // Specific checks to perform
    trustedIssuers?: string[]; // List of trusted issuer DIDs
  };
  createdAt: string;          // ISO timestamp
}
```

#### Verification Result

```typescript
interface VerificationResult {
  id: string;                 // UUID for the result
  requestId: string;          // Reference to verification request
  isValid: boolean;           // Overall validity
  checks: {
    structure: boolean;       // Structure validation passed
    signature: boolean;       // Signature validation passed
    expiration: boolean;      // Expiration validation passed
    revocation?: boolean;     // Revocation status check passed
    issuerTrust: boolean;     // Issuer is trusted
  };
  errors: VerificationError[]; // Any errors encountered
  createdAt: string;          // ISO timestamp
}

interface VerificationError {
  code: string;               // Error code
  message: string;            // Error description
  check: string;              // Which check failed
}
```

### FEP (Frontend Portal)

#### User

```typescript
interface User {
  id: string;                 // UUID
  username: string;           // Username
  email: string;              // Email address
  password: string;           // Hashed password
  webId?: string;             // WebID if connected to PDS
  pdsUrl?: string;            // PDS URL if connected
  createdAt: string;          // ISO timestamp
  updatedAt: string;          // ISO timestamp
}
```

#### Application

```typescript
interface Application {
  id: string;                 // UUID
  userId: string;             // User ID reference
  type: string;               // Application type
  status: 'draft' | 'submitted' | 'approved' | 'rejected';
  data: object;               // Application form data
  credentials: string[];      // Linked credential IDs
  createdAt: string;          // ISO timestamp
  updatedAt: string;          // ISO timestamp
}
```

#### PDS Connection

```typescript
interface PdsConnection {
  id: string;                 // UUID
  userId: string;             // User ID reference
  clientId: string;           // OAuth client ID
  accessToken: string;        // Encrypted access token
  refreshToken: string;       // Encrypted refresh token
  expiresAt: string;          // ISO timestamp
  createdAt: string;          // ISO timestamp
  updatedAt: string;          // ISO timestamp
}
```

## Data Validation

All services must validate data against these models using JSON Schema or equivalent validation mechanisms. Each service should provide a validation schema that matches these data models.

## Migration Guidelines

When model changes are required:

1. Always implement backward compatibility layers
2. Use versioned APIs to manage model evolution
3. Support data migration paths for existing data
4. Document migration procedures clearly

## Cross-Service Data Exchange

When exchanging data between services:

1. Use consistent field names across services
2. Follow REST or GraphQL conventions for resource representation
3. Include only necessary fields to minimize payload size
4. Validate incoming and outgoing data against the defined models

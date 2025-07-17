# Updated Architecture and Auth Flows

## Revised Architecture

The system consists of the following microservices:

1. **API Registry** - Central registry for service API discovery and documentation
2. **Solid PDS** - Personal Data Store based on Community Solid Server for hosting user data and WebIDs
3. **Test VC Creator (DRO)** - Emulates a Departmental Records Office, issuing birth and marriage certificates as verifiable credentials using did:web
4. **VC Verifier** - Service for verifying credentials presented by users
5. **MERN App** - Benefits application with PDS integration for credential verification

Each service operates independently with its own did:web implementation where needed.

## Key Changes: Removal of Central DID Registry

In the previous architecture, a central DID Registry service was used to manage decentralized identifiers. The updated architecture removes this component in favor of a more distributed approach:

- Each service that requires a DID now implements the `did:web` method directly
- DIDs are exposed at the standard endpoint `/.well-known/did.json` on each service's domain
- Services resolve DIDs directly from their source domains rather than through a central registry

### Benefits of the Updated Approach

1. **Simplified Architecture**: Removing a central component reduces complexity
2. **Improved Resilience**: No single point of failure for DID resolution
3. **Standards Compliance**: Direct implementation of the `did:web` method aligns with W3C standards
4. **Reduced Maintenance**: One less service to maintain and update

## did:web Implementation

### DRO Service
- Exposes DID document at `https://dro.gov.uk.local/.well-known/did.json`
- Manages its own keys for signing credentials
- No dependency on external DID registry

### MERN App
- Exposes DID document at `https://benefits.gov.uk.local/.well-known/did.json`
- Manages its own keys for authentication
- No dependency on external DID registry

### VC Verifier
- Exposes DID document at `https://verifier.gov.uk.local/.well-known/did.json`
- Resolves issuer DIDs directly from their domains for credential verification
- Validates credentials against the public keys in the issuer's DID document

### Solid PDS
- Manages user WebIDs
- Handles user authentication and authorization
- Stores user credentials

### API Registry
- Provides service discovery
- No DID-related functionality needed

## Authentication & Authorization Flows

### User Registration and DID Creation
1. User registers with Solid PDS service
2. PDS creates a WebID for the user (e.g., `https://pds.local/username/profile/card#me`)
3. PDS sets up the necessary storage for the user's data

### DRO Authentication Flow
1. User registers directly with the DRO service
2. User authenticates to the DRO service
3. User provides their WebID/PDS location
4. DRO requests permission to store credentials in the user's PDS
5. DRO issues credentials and stores them in the user's PDS
6. DRO's did:web identity can be verified by accessing `https://dro.gov.uk.local/.well-known/did.json`

### MERN App Authorization Flow
1. MERN app is registered as a client with the Solid PDS
2. User grants one-time permission to the MERN app to access specific resources
3. MERN app receives access and refresh tokens
4. MERN app uses tokens to access authorized resources without further redirects
5. MERN app requests verification of credentials by the VC Verifier service
6. VC Verifier verifies credentials by:
   - Checking the credential issuer (DRO's did:web)
   - Resolving the DID document at `https://dro.gov.uk.local/.well-known/did.json`
   - Verifying the signature using the public key in the DID document

## DID Resolution Process

1. When a service needs to resolve a DID (e.g., `did:web:dro.gov.uk.local`):
   - It converts the DID to a URL: `https://dro.gov.uk.local/.well-known/did.json`
   - It retrieves the DID document directly from that URL
   - It uses the public keys and other information in the DID document as needed

2. For credential verification:
   - The VC Verifier extracts the issuer DID from the credential
   - It resolves the DID document directly from the issuer's domain
   - It verifies the credential signature using the public key from the DID document

## Domain Emulation

To emulate different domains locally:

1. Configure /etc/hosts entries:
   ```
   127.0.0.1  pds.local
   127.0.0.1  dro.gov.uk.local
   127.0.0.1  benefits.gov.uk.local
   127.0.0.1  verifier.gov.uk.local
   ```

2. Use nginx as a reverse proxy to route requests to the appropriate services:
   ```
   # Example nginx configuration
   server {
     listen 80;
     server_name dro.gov.uk.local;
     location / {
       proxy_pass http://DRO:3002;
     }
   }
   
   server {
     listen 80;
     server_name benefits.gov.uk.local;
     location / {
       proxy_pass http://FEP:3003;
     }
   }
   
   server {
     listen 80;
     server_name verifier.gov.uk.local;
     location / {
       proxy_pass http://vc-verifier:3004;
     }
   }
   ```

3. Generate self-signed certificates for HTTPS support

## Implementation Requirements

Each service that needs a DID must:

1. Generate and securely store its own keypair
2. Create a valid DID document according to the did:web specification
3. Serve the DID document at the `/.well-known/did.json` endpoint
4. Implement DID resolution for other services' DIDs

## Implementation Changes

### Changes to docker-compose.yml
- Remove the DID Registry service
- Update service dependencies
- Add environment variables for direct did:web resolution

### Changes to Test VC Creator (DRO)
- Implement direct did:web functionality
- Remove references to external DID Registry
- Add endpoint to expose DID document at `/.well-known/did.json`
- Implement GOV.UK style guide compliant UI

### Changes to MERN App
- Implement direct did:web functionality
- Remove references to external DID Registry
- Add endpoint to expose DID document at `/.well-known/did.json`
- Update to use VC Verifier service for credential verification
- Integrate with existing evidence upload/extraction facility

### Changes to VC Verifier
- Update to use direct did:web resolution
- Remove references to external DID Registry
- Add endpoint to expose DID document at `/.well-known/did.json` if needed
- Implement GOV.UK style guide compliant UI

## UI Requirements

Each service requires a GOV.UK Design System compliant UI:

1. **Solid PDS**:
   - User registration
   - Login
   - Data management

2. **Test VC Creator (DRO)**:
   - User registration
   - Authentication
   - Credential request and issuance

3. **VC Verifier**:
   - Verification interface
   - Credential status display
   - Error handling and feedback

4. **MERN App**:
   - User registration
   - Authentication
   - PDS connection
   - Credential verification integration
   - Benefit application management

## Security Considerations

The distributed DID approach maintains the security properties of the previous architecture while reducing complexity. Each service is responsible for:

- Securing its private keys
- Properly implementing DID resolution
- Validating credentials according to W3C VC standards

All services must be fully functional without any placeholders, implement proper error handling, and follow the GOV.UK style guidelines for accessibility and user experience.

## Testing Requirements

All services must include comprehensive test suites covering:

1. Unit tests for core functionality
2. Integration tests for service interactions
3. End-to-end tests for user flows
4. Security tests for credential verification and authentication

## Deployment and Documentation

Documentation for each service should be updated to reflect the new architecture and removal of the DID Registry dependency. This includes:

1. Updated README files
2. Updated API documentation
3. Updated integration guides
4. Updated deployment instructions

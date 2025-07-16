# Solid Microservices Architecture and Authentication Flows

## Core Services & Authentication Mechanisms

### 1. Solid PDS (Personal Data Store)
- **Authentication System:** Standard Solid WebID-OIDC
- **User Identity:** WebID (HTTPS URL that represents the user)
- **Auth Tokens:** Issues OAuth2 access and refresh tokens
- **Registration:** Self-registration for end users

### 2. DRO (Departmental Records Office)
- **Authentication System:** Custom JWT-based authentication
- **User Identity:** Email/password with JWT tokens
- **Registration:** Self-registration or admin-created accounts

### 3. MERN App (Benefits Application)
- **Authentication System:** Custom JWT-based authentication
- **User Identity:** Email/password with JWT tokens
- **Registration:** Self-registration for benefit applicants

### 4. API Registry
- **Authentication System:** API key authentication
- **Service Identity:** Service name and version
- **Registration:** Automatic during service startup

## Authentication & Authorization Flows

### Flow 1: MERN App → PDS Authorization
1. User authenticates in MERN App (JWT).
2. MERN App registers as OAuth client with PDS and stores credentials.
3. User clicks "Connect to My PDS"; MERN App redirects to PDS for OAuth consent.
4. User authenticates and consents in PDS.
5. PDS redirects back to MERN App with code; MERN App exchanges for tokens.
6. MERN App uses access_token to access PDS; refreshes as needed.

### Flow 2: DRO → PDS Authorization
1. User authenticates in DRO (JWT).
2. DRO registers as OAuth client with PDS and stores credentials.
3. User provides PDS URL in DRO; DRO redirects to PDS for OAuth consent.
4. User authenticates and consents in PDS.
5. PDS redirects back to DRO with code; DRO exchanges for tokens.
6. DRO uses access_token to store credentials in user's PDS.

### Flow 3: Credential Verification via did:web
1. DRO exposes its DID document at `https://dro.gov.uk.local/.well-known/did.json`.
2. MERN App fetches this document to verify credentials issued by DRO.
3. Signature verification uses public key from DID document.

## Service Registration & Discovery
- All services publish their OpenAPI specs to API Registry at startup.
- Services fetch other services' specs from API Registry for integration.

## Complete User Journey Example
1. User registers on PDS, DRO, and MERN App.
2. User requests credential from DRO, authorizes DRO to write to PDS.
3. DRO issues and stores credential in user's PDS.
4. User connects MERN App to PDS, selects credential, and submits benefit application.
5. MERN App verifies credential using did:web.

## Technical Implementation Details
- **Nginx**: Handles local domain routing and SSL for did:web.
- **Hosts File**: Maps local domains to 127.0.0.1.
- **Token Storage**: Each service stores its own JWTs and PDS OAuth tokens securely.
- **Environment Variables**: Each service is configured with its own and other services' URLs.

---

This document describes the agreed architecture and authentication flows for the Solid microservices system. All implementation should follow these patterns for consistency and interoperability.

# Personal Data Store (PDS) Microservices System

This project implements a modular microservices-based prototype for handling verifiable credentials with a Solid-compliant Personal Data Store (PDS). The system enables users to obtain verifiable credentials from a government department simulator (DRO) and use them in a benefits application, all while maintaining control of their personal data.

## Architecture

The system consists of the following microservices:

1. **API Registry** - Central registry for service API discovery and documentation
2. **DID Registry** - Registry for did:web identifiers and DID documents
3. **Solid PDS** - Personal Data Store based on Community Solid Server for hosting user data
4. **VC Verifier** - Service for verifying credentials using DID resolution
5. **Test VC Creator (DRO)** - Emulates a Departmental Records Office, issuing birth and marriage certificates as verifiable credentials using did:web
6. **MERN App** - Benefits application with PDS integration for credential verification

## Directory Structure

```
PDS/
├── docker-compose.yml          # Container orchestration
├── BUILDING_GUIDE.md           # Guide for building each service
├── IMPLEMENTATION_VERIFICATION.md # Verification of implementation guides
├── nginx/                      # Reverse proxy configuration for domain emulation
│   ├── conf/                   # Nginx configuration files
│   └── certs/                  # Self-signed certificates for HTTPS
├── api-registry/               # API Registry service
│   └── specifications/         # API specifications
├── did-registry/               # DID Registry service
│   └── specifications/         # API specifications
├── solid-pds/                  # Solid PDS service
│   └── specifications/         # API specifications
├── test-vc-creator/            # DRO service for issuing credentials
│   └── specifications/         # API specifications
├── vc-verifier/                # Service for verifying credentials
│   └── specifications/         # API specifications
├── mern-app/                   # Benefits application with PDS integration
│   └── specifications/         # API specifications
└── data/                       # Persistent data storage
    ├── api-registry/
    ├── did-registry/
    ├── solid-pds/
    ├── test-vc-creator/
    ├── vc-verifier/
    └── mern-app/
```

## Authentication & Authorization Flows

### DRO Authentication Flow
1. User registers directly with the DRO service
2. User authenticates to the DRO service
3. User provides their WebID/PDS location
4. DRO requests permission to store credentials in the user's PDS
5. DRO issues and stores credentials in the user's PDS

### MERN App Authorization Flow
1. MERN app is registered as a client with the Solid PDS
2. User grants one-time permission to the MERN app to access specific resources
3. MERN app receives access and refresh tokens
4. MERN app uses tokens to access authorized resources without further redirects
5. Tokens are refreshed automatically when needed

## Getting Started

### Prerequisites

- Docker and Docker Compose
- Git
- Node.js 18+ (for development)
- macOS with ability to edit /etc/hosts (for local domain emulation)

### Installation and Setup

1. Clone the repository:
   ```
   git clone <repository-url>
   cd PDS
   ```

2. Setup local domain emulation by adding these entries to your /etc/hosts file:
   ```
   127.0.0.1  pds.local
   127.0.0.1  dro.gov.uk.local
   127.0.0.1  benefits.gov.uk.local
   ```

3. Generate self-signed certificates (script included):
   ```
   ./scripts/generate-certs.sh
   ```

4. Start the system:
   ```
   docker-compose up -d
   ```

5. Access the services:
   - API Registry: http://localhost:3005
   - DID Registry: http://localhost:3001
   - Solid PDS: https://pds.local
   - VC Verifier: http://localhost:3004
   - DRO Service: https://dro.gov.uk.local
   - Benefits App: https://benefits.gov.uk.local

## Service Development

Each microservice is designed to be developed independently, with integration through the API Registry. Service APIs are defined using OpenAPI specifications.

### Developing a Service

1. Navigate to the service directory
2. Review the specifications folder for API requirements
3. Follow the implementation guide in the service directory
4. Implement the service according to the requirements
5. Test the service using the provided test framework
6. Build and run the service using Docker

### Building All Services

To build and run all services together, follow the instructions in the `BUILDING_GUIDE.md` file, which provides a step-by-step guide for building each service with GitHub Copilot.

### Implementation Requirements

All services must be fully implemented with:
- Complete functionality (no placeholders or stubs)
- GOV.UK Design System compliant user interfaces
- Comprehensive test coverage
- Production-ready code

## Documentation

- `BUILDING_GUIDE.md` - Step-by-step guide for building each service
- `IMPLEMENTATION_VERIFICATION.md` - Verification of implementation guides
- `REPOSITORY_CLEANUP_PLAN.md` - Plan for cleaning up the repository
- Service-specific implementation guides in each service directory
3. Implement the service according to specifications
4. Publish the API specification to the API Registry
5. Test the service with its defined API tests

### Service Integration

Services integrate with each other by:
1. Discovering API specifications from the API Registry
2. Using the API specifications to make standardized requests
3. Following the defined authentication/authorization patterns

## License

[Specify License]

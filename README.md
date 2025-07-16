# Personal Data Store (PDS) Microservices System

This project implements a modular microservices-based prototype for handling verifiable credentials with a Solid-compliant Personal Data Store (PDS). The system enables users to obtain verifiable credentials from a government department simulator (DRO) and use them in a Frontend Portal application, all while maintaining control of their personal data.

## Architecture

The system consists of the following microservices:

1. **API Registry** - Central registry for service API discovery and documentation
2. **Solid PDS** - Personal Data Store based on Community Solid Server for hosting user data and WebIDs
3. **DRO** - Emulates a Departmental Records Office, issuing birth and marriage certificates as verifiable credentials using did:web
4. **VC Verifier** - Service for verifying credentials using direct did:web resolution
5. **FEP** - Frontend Portal application with PDS integration for credential verification

Each service implements did:web directly where needed, without relying on a central DID Registry. For more details on the updated architecture, see [docs/UPDATED_ARCHITECTURE.md](./docs/UPDATED_ARCHITECTURE.md).

## Directory Structure

```
PDS/
├── docker-compose.yml          # Container orchestration
├── docs/                       # Documentation
│   ├── BUILDING_GUIDE.md       # Guide for building each service
│   ├── BUILD_AND_DEPLOY_GUIDE.md # Detailed build and deployment guide
│   ├── DID_MIGRATION_GUIDE.md  # Guide for migrating to direct did:web
│   ├── IMPLEMENTATION_VERIFICATION.md # Verification of implementation
│   ├── MICROSERVICES_BEST_PRACTICES.md # Best practices guide
│   ├── SERVICE_IMPLEMENTATION_CHECKLIST.md # Implementation checklist
│   ├── UPDATED_ARCHITECTURE.md # Updated architecture documentation
│   └── ARCHITECTURE_UPDATE_SUMMARY.md # Architecture update summary
├── scripts/                    # Utility scripts
│   ├── setup_hosts.sh          # Script to set up local host entries
│   └── setup_nginx.sh          # Script to set up nginx configuration
├── nginx/                      # Reverse proxy configuration
│   ├── conf/                   # Nginx configuration files
│   └── certs/                  # Self-signed certificates for HTTPS
├── api-registry/               # API Registry service
│   └── specifications/         # API specifications
├── solid-pds/                  # Solid PDS service
│   └── specifications/         # API specifications
├── DRO/                  # DRO service for issuing credentials
│   └── specifications/         # API specifications
├── vc-verifier/                # Service for verifying credentials
│   └── specifications/         # API specifications
├── FEP/                   # Frontend Portal application with PDS integration
│   └── specifications/         # API specifications
└── data/                       # Persistent data storage
    ├── api-registry/
    ├── solid-pds/
    ├── DRO/
    ├── vc-verifier/
    └── FEP/
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
   - Solid PDS: https://pds.local
   - VC Verifier: http://localhost:3004 or https://verifier.gov.uk.local
   - DRO Service: https://dro.gov.uk.local
   - Benefits App: https://benefits.gov.uk.local

## Setup Instructions

1. Clone this repository:
   ```
   git clone https://github.com/mrchughes/solid-project-parent.git
   cd solid-project-parent
   ```

2. Set up host entries (requires root/admin privileges):
   ```
   sudo ./scripts/setup_hosts.sh
   ```

3. Set up the nginx configuration:
   ```
   ./scripts/setup_nginx.sh
   ```

4. Start the services:
   ```
   docker-compose up -d
   ```

5. For implementation details for each service, refer to:
   - [DID Migration Guide](./docs/DID_MIGRATION_GUIDE.md) for implementing did:web
   - [Updated Architecture](./docs/UPDATED_ARCHITECTURE.md) for architecture details
   - Individual service README files for specific implementation requirements

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

To build and run all services together, follow the instructions in the `docs/BUILDING_GUIDE.md` file, which provides a step-by-step guide for building each service with GitHub Copilot.

### Implementation Requirements

All services must be fully implemented with:
- Complete functionality (no placeholders or stubs)
- GOV.UK Design System compliant user interfaces
- Comprehensive test coverage
- Production-ready code

## Documentation

All project documentation is located in the `docs/` directory:

- `docs/BUILDING_GUIDE.md` - Step-by-step guide for building each service
- `docs/BUILD_AND_DEPLOY_GUIDE.md` - Detailed build and deployment guide
- `docs/IMPLEMENTATION_VERIFICATION.md` - Verification of implementation guides
- `docs/UPDATED_ARCHITECTURE.md` - Updated architecture documentation
- `docs/ARCHITECTURE_UPDATE_SUMMARY.md` - Summary of architecture changes
- `docs/DID_MIGRATION_GUIDE.md` - Guide for migrating to direct did:web implementation
- `docs/MICROSERVICES_BEST_PRACTICES.md` - Best practices for loose coupling and high cohesion
- `docs/SERVICE_IMPLEMENTATION_CHECKLIST.md` - Checklist for service implementation

Each service also has its own implementation guide in its respective directory.

### Service Integration

Services integrate with each other by:
1. Discovering API specifications from the API Registry
2. Using the API specifications to make standardized requests
3. Following the defined authentication/authorization patterns
4. Resolving DIDs directly using the did:web method

## Independent Building and Testing

Each microservice in this system can be built and tested independently:

1. Each service has its own repository with complete documentation
2. Services interact only through published API contracts via the API Registry
3. Services have no direct knowledge of other services' internal implementations
4. Dependencies are specified via environment variables with clear defaults

To build any service independently:

```bash
# Navigate to the service directory
cd service-name

# Install dependencies
npm install

# Run tests
npm test

# Start the service
npm start
```

## License

[Specify License]

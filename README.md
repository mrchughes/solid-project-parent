# Personal Data Store (PDS) Microservices System

This project implements a modular microservices-based prototype for handling verifiable credentials with a Solid-compliant Personal Data Store (PDS). The system enables users to obtain verifiable credentials from a government department simulator (DRO) and use them in a Frontend Portal application, all while maintaining control of their personal data.

## Architecture

The system consists of the following microservices:

1. **API Registry** - Central registry for service API discovery and documentation
2. **Solid PDS** - Personal Data Store based on Community Solid Server for hosting user data and WebIDs
3. **DRO** - Departmental Records Office, issuing birth and marriage certificates as verifiable credentials using did:web
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
│   ├── ERROR_HANDLING_STANDARDS.md # Standard error handling format
│   ├── DATA_MODELS.md          # Standard data models across services
│   ├── GOVUK_DESIGN_SYSTEM_GUIDE.md # UI implementation guidelines
│   ├── IMPLEMENTATION_VERIFICATION.md # Verification of implementation
│   ├── MICROSERVICES_BEST_PRACTICES.md # Best practices guide
│   ├── SERVICE_IMPLEMENTATION_CHECKLIST.md # Implementation checklist
│   ├── UPDATED_ARCHITECTURE.md # Updated architecture documentation
│   └── ARCHITECTURE_UPDATE_SUMMARY.md # Architecture update summary
├── shell/                      # Shell scripts for setup and management
│   ├── setup_hosts.sh          # Script to set up local host entries
│   ├── setup_nginx.sh          # Script to set up nginx configuration
│   ├── generate-certs.sh       # Script to generate certificates
│   ├── copy_standards.sh       # Script to copy standards to services
│   └── cleanup-services.sh     # Script to clean up services
├── nginx/                      # Reverse proxy configuration
│   ├── conf/                   # Nginx configuration files
│   └── certs/                  # Self-signed certificates for HTTPS
├── api-registry/               # API Registry service
│   ├── docs/                   # Documentation for API Registry
│   │   ├── README-IMPLEMENTATION.md # Detailed implementation guide
│   │   └── IMPLEMENTATION_GUIDE.md # Implementation guide
│   └── specifications/         # API specifications
├── solid-pds/                  # Solid PDS service
│   ├── docs/                   # Documentation for Solid PDS
│   │   ├── README-IMPLEMENTATION.md # Detailed implementation guide
│   │   └── IMPLEMENTATION_GUIDE.md # Implementation guide
│   └── specifications/         # API specifications
├── DRO/                        # DRO service for issuing credentials
│   ├── docs/                   # Documentation for DRO
│   │   ├── README-IMPLEMENTATION.md # Detailed implementation guide
│   │   └── IMPLEMENTATION_GUIDE.md # Implementation guide
│   └── specifications/         # API specifications
├── vc-verifier/                # Service for verifying credentials
│   ├── docs/                   # Documentation for VC Verifier
│   │   ├── README-IMPLEMENTATION.md # Detailed implementation guide
│   │   └── IMPLEMENTATION_GUIDE.md # Implementation guide
│   └── specifications/         # API specifications
├── FEP/                        # Frontend Portal application with PDS integration
│   ├── docs/                   # Documentation for FEP
│   │   ├── README-IMPLEMENTATION.md # Detailed implementation guide
│   │   └── IMPLEMENTATION_GUIDE.md # Implementation guide
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
2. User authenticates to the DRO service using JWT-based authentication
3. User provides their WebID/PDS location
4. DRO requests permission to store credentials in the user's PDS
5. DRO issues and stores credentials in the user's PDS

### FEP Authorization Flow
1. FEP app is registered as a client with the Solid PDS
2. User grants one-time permission to the FEP app to access specific resources
3. FEP app receives access and refresh tokens
4. FEP app uses tokens to access authorized resources without further redirects
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

2. Setup local domain emulation by adding these entries to your /etc/hosts file (or use the provided script):
   ```
   127.0.0.1  pds.local
   127.0.0.1  dro.gov.uk.local
   127.0.0.1  fep.gov.uk.local
   127.0.0.1  verifier.gov.uk.local
   ```
   
   ```bash
   sudo ./shell/setup_hosts.sh
   ```

3. Generate self-signed certificates:
   ```
   ./shell/generate-certs.sh
   ```

4. Create a `.env` file at the root of the project with the following variables:
   ```
   # General
   NODE_ENV=development
   LOG_LEVEL=info

   # Security
   JWT_SECRET=your_secure_jwt_secret
   COOKIE_SECRET=your_secure_cookie_secret
   SESSION_SECRET=your_secure_session_secret

   # API Keys
   API_REGISTRY_KEY=your_secure_api_key
   ADMIN_API_KEY=your_secure_admin_key

   # MongoDB
   MONGO_ROOT_USERNAME=admin
   MONGO_ROOT_PASSWORD=secure_password
   ```

5. Start the system:
   ```
   docker-compose up -d
   ```

6. Access the services:
   - API Registry: http://localhost:3005
   - Solid PDS: https://pds.local
   - VC Verifier: http://localhost:3004 or https://verifier.gov.uk.local
   - DRO Service: https://dro.gov.uk.local
   - FEP App: https://fep.gov.uk.local

## Standardization Improvements

Recent system-wide improvements include:

1. **Standardized Error Handling**: Common error format and codes across all services
   - See [Error Handling Standards](./docs/ERROR_HANDLING_STANDARDS.md)

2. **Consistent Data Models**: Standardized data models for all services
   - See [Data Models](./docs/DATA_MODELS.md)

3. **UI Standards**: GOV.UK Design System implementation guide
   - See [GOV.UK Design System Guide](./docs/GOVUK_DESIGN_SYSTEM_GUIDE.md)

4. **Environment Variables**: Moved from hardcoded values to environment variables
   - See [Build and Deploy Guide](./docs/BUILD_AND_DEPLOY_GUIDE.md)

5. **Service Documentation**: Each service has its own comprehensive README-IMPLEMENTATION.md

6. **Distributed Standards**: All standards documents are copied to each service directory
   - Use [Standards Implementation Guide](./docs/STANDARDS_IMPLEMENTATION_GUIDE.md) for guidance
   - Standards can be updated using the `scripts/copy_standards.sh` script

## Service Development

Each microservice is designed to be developed independently, with integration through the API Registry. Service APIs are defined using OpenAPI specifications.

### Developing a Service

1. Navigate to the service directory
2. Review the specifications folder for API requirements
3. Follow the implementation guide in the service directory
4. Implement the service according to the requirements
5. Test the service using the provided test framework
6. Build and run the service using Docker

### Implementation Requirements

All services must be fully implemented with:
- Complete functionality (no placeholders or stubs)
- GOV.UK Design System compliant user interfaces
- Comprehensive test coverage (minimum 80%)
- Standardized error handling
- Environment variable configuration
- Standard data models
- Production-ready code

## Documentation

All project documentation is located in the `docs/` directory:

- `docs/BUILDING_GUIDE.md` - Step-by-step guide for building each service
- `docs/BUILD_AND_DEPLOY_GUIDE.md` - Detailed build and deployment guide
- `docs/ERROR_HANDLING_STANDARDS.md` - Standard error handling format
- `docs/DATA_MODELS.md` - Standard data models across services
- `docs/GOVUK_DESIGN_SYSTEM_GUIDE.md` - UI implementation guidelines
- `docs/IMPLEMENTATION_VERIFICATION.md` - Verification of implementation guides
- `docs/UPDATED_ARCHITECTURE.md` - Updated architecture documentation
- `docs/ARCHITECTURE_UPDATE_SUMMARY.md` - Summary of architecture changes
- `docs/DID_MIGRATION_GUIDE.md` - Guide for migrating to direct did:web implementation
- `docs/MICROSERVICES_BEST_PRACTICES.md` - Best practices for loose coupling and high cohesion
- `docs/SERVICE_IMPLEMENTATION_CHECKLIST.md` - Checklist for service implementation

Each service also has its own detailed implementation guide in its respective directory.

### Service Integration

Services integrate with each other by:
1. Discovering API specifications from the API Registry
2. Using the API specifications to make standardized requests
3. Following the defined authentication/authorization patterns
4. Resolving DIDs directly using the did:web method
5. Following standardized error handling and data models

## Security Considerations

- All API keys should be rotated regularly
- JWT secrets should be secure and environment-specific
- Always use HTTPS in production
- Implement proper input validation
- Follow the principle of least privilege
- Ensure proper access controls for all endpoints
- See [security section in each service README-IMPLEMENTATION.md]

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

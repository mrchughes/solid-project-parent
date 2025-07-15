# Personal Data Store (PDS) Microservices System

This project implements a modular microservices-based system that includes a Solid-compliant Personal Data Store (PDS), services for issuing and verifying Verifiable Credentials (VCs), a user interface for WebID-based authentication and credential management, and integration with a MERN stack benefit application.

## Architecture

The system consists of the following microservices:

1. **Solid PDS** - Hosts user pods and WebIDs using Community Solid Server
2. **DID Registry Service** - Manages DIDs and DID Documents
3. **Test VC Creator Service** - Generates and signs mock credentials and stores them in user's PDS
4. **VC Verifier Service** - Verifies VCs using DID resolution and signature validation
5. **React UI** - User interface for registration, login, and VC management
6. **MERN App** - Benefit application that authenticates WebIDs and verifies VCs

## Directory Structure

```
PDS/
├── docker-compose.yml
├── src/
│   ├── solid-pds/
│   │   └── specifications/
│   ├── did-registry/
│   │   └── specifications/
│   ├── test-vc-creator/
│   │   └── specifications/
│   ├── vc-verifier/
│   │   └── specifications/
│   ├── react-ui/
│   │   └── specifications/
│   └── mern-app/
│       └── specifications/
└── data/
    ├── solid-pds/
    ├── did-registry/
    ├── test-vc-creator/
    └── vc-verifier/
```

## Getting Started

### Prerequisites

- Docker and Docker Compose
- Git

### Installation and Setup

1. Clone the repository:
   ```
   git clone <repository-url>
   cd PDS
   ```

2. Start the system:
   ```
   docker-compose up -d
   ```

3. Access the services:
   - Solid PDS: http://localhost:3000
   - DID Registry: http://localhost:3001
   - Test VC Creator: http://localhost:3002
   - VC Verifier: http://localhost:3003
   - React UI: http://localhost:3004
   - MERN App: http://localhost:3005

## Service Specifications

Each microservice has its own specifications folder with API documentation. Refer to these specifications for integration details.

## Development

To develop or modify a specific microservice:

1. Navigate to the service directory:
   ```
   cd src/<service-name>
   ```

2. Make your changes

3. Rebuild and restart the service:
   ```
   docker-compose up -d --build <service-name>
   ```

## Data Persistence

All data is stored in the `./data` directory, with each service having its own subdirectory. This ensures data persists between container restarts.

## License

[Specify License]

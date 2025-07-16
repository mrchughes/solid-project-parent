# Dummy's Guide to Building the PDS Microservices System

This guide provides step-by-step instructions for building each service in the Personal Data Store (PDS) microservices system using GitHub Copilot. Follow this guide to ensure you build the services in the correct order, with each one properly integrating with the others.

## Critical Implementation Requirements

All services must meet these critical requirements:

1. **Fully Functional Implementation**: All services must be completely implemented with no placeholders, stubs, or "to be implemented" sections. Every feature described in the implementation guides must be fully functional.

2. **GOV.UK Design System Compliance**: All user interfaces must comply with the GOV.UK Design System style guide. This includes typography, color schemes, form elements, error handling, and accessibility requirements.

3. **Production-Ready Code**: Code should be robust, well-tested, and ready for production deployment.

## Prerequisites

Before you begin:

1. Make sure you have Docker and Docker Compose installed
2. Ensure Node.js 18+ is installed
3. Have Git configured on your machine
4. Have GitHub Copilot installed in VS Code
5. Clone the PDS parent repository
6. Familiarize yourself with the [GOV.UK Design System](https://design-system.service.gov.uk/)

## Build Order

Building the services in the correct order is important to ensure proper integration. Here's the recommended build order:

1. **API Registry** - Build first as other services will register with it
2. **DID Registry** - Build second as credential-related services need it
3. **Solid PDS** - Build third as it's the core data storage for credentials
4. **VC Verifier** - Build fourth to verify credentials
5. **Test VC Creator (DRO)** - Build fifth to issue credentials to the PDS
6. **MERN App** - Build last to consume and verify credentials from the PDS

## Step-by-Step Guide

### 1. Building the API Registry

```
cd /Users/chrishughes/Projects/PDS/api-registry
```

1. **Open the Implementation Guide**:
   - Open `IMPLEMENTATION_GUIDE.md` to understand the requirements and implementation steps
   
2. **Ask Copilot to implement the core service**:
   - Prompt: "Implement the API Registry service based on the implementation guide, starting with the API storage schema"
   
3. **Build the API controllers**:
   - Prompt: "Implement the API controllers for managing service specifications"
   
4. **Implement the authentication middleware**:
   - Prompt: "Implement the API key authentication middleware"
   
5. **Set up the routes**:
   - Prompt: "Create the Express routes for the API Registry"
   
6. **Test the implementation**:
   - Prompt: "Implement tests for the API Registry service"
   
7. **Build and run the service**:
   - Run: `docker build -t api-registry .`
   - Run: `docker run -p 3005:3005 api-registry`

### 2. Building the DID Registry

```
cd /Users/chrishughes/Projects/PDS/did-registry
```

1. **Open the Implementation Guide**:
   - Open `IMPLEMENTATION_GUIDE.md` to understand the requirements and implementation steps
   
2. **Ask Copilot to implement the DID service**:
   - Prompt: "Implement the DID management service based on the implementation guide"
   
3. **Create the DID Document manager**:
   - Prompt: "Implement the DID Document management functionality"
   
4. **Implement did:web resolution**:
   - Prompt: "Create the did:web resolver functionality"
   
5. **Create the API integration**:
   - Prompt: "Implement the API Registry integration for the DID Registry"
   
6. **Set up authentication**:
   - Prompt: "Implement JWT authentication for the DID Registry API"
   
7. **Test the implementation**:
   - Prompt: "Create tests for the DID Registry service"
   
8. **Build and run the service**:
   - Run: `docker build -t did-registry .`
   - Run: `docker run -p 3001:3001 did-registry`

### 3. Building the Solid PDS

```
cd /Users/chrishughes/Projects/PDS/solid-pds
```

1. **Open the Implementation Guide**:
   - Open `IMPLEMENTATION_GUIDE.md` to understand the requirements and implementation steps
   
2. **Set up the Solid Community Server**:
   - Prompt: "Set up the Solid Community Server with the configuration from the implementation guide"
   
3. **Implement OAuth integration**:
   - Prompt: "Implement the OAuth 2.0 client configuration for service-to-service authentication"
   
4. **Create credential storage**:
   - Prompt: "Implement the credential storage handler for the Solid PDS"
   
5. **Set up API Registry integration**:
   - Prompt: "Create the API Registry client for the Solid PDS"
   
6. **Implement custom routes**:
   - Prompt: "Implement the custom routes for OAuth and credentials"

7. **Implement GOV.UK compliant UI**:
   - Prompt: "Create a GOV.UK Design System compliant user interface for the Solid PDS, including registration, login, and WebID management screens"
   
8. **Test the implementation**:
   - Prompt: "Create comprehensive tests for the Solid PDS service"
   
9. **Build and run the service**:
   - Run: `docker build -t solid-pds .`
   - Run: `docker run -p 3000:3000 solid-pds`

### 4. Building the VC Verifier

```
cd /Users/chrishughes/Projects/PDS/vc-verifier
```

1. **Open the Implementation Guide**:
   - Open `IMPLEMENTATION_GUIDE.md` to understand the requirements and implementation steps
   
2. **Create the verification service**:
   - Prompt: "Implement the credential verification service based on the implementation guide"
   
3. **Implement the did:web resolver**:
   - Prompt: "Create the did:web resolver integration for the VC Verifier"
   
4. **Set up verification policies**:
   - Prompt: "Implement the verification policies for different credential types"
   
5. **Create API endpoints**:
   - Prompt: "Create the API endpoints for credential verification"
   
6. **Implement API Registry integration**:
   - Prompt: "Implement the API Registry integration for the VC Verifier"
   
7. **Test the implementation**:
   - Prompt: "Create comprehensive tests for the VC Verifier service, including all verification scenarios"
   
8. **Build and run the service**:
   - Run: `docker build -t vc-verifier .`
   - Run: `docker run -p 3002:3002 vc-verifier`

### 5. Building the DRO

```
cd /Users/chrishughes/Projects/PDS/DRO
```

1. **Open the Implementation Guide**:
   - Open `IMPLEMENTATION_GUIDE.md` to understand the requirements and implementation steps
   
2. **Implement user authentication**:
   - Prompt: "Implement the JWT-based authentication system for the DRO service"
   
3. **Create the did:web identity**:
   - Prompt: "Create the did:web identity implementation with the .well-known endpoint"
   
4. **Implement PDS integration**:
   - Prompt: "Implement the Solid PDS integration with OAuth authentication"
   
5. **Create credential issuance**:
   - Prompt: "Implement the credential issuance functionality for birth and marriage certificates"
   
6. **Implement GOV.UK compliant UI**:
   - Prompt: "Create a GOV.UK Design System compliant user interface for the DRO service, including registration, login, credential request, and issuance confirmation screens"
   
7. **Set up API Registry integration**:
   - Prompt: "Create the API Registry integration for the Test VC Creator"
   
8. **Test the implementation**:
   - Prompt: "Create comprehensive tests for the Test VC Creator service, including all credential issuance flows"
   
9. **Build and run the service**:
   - Run: `docker build -t DRO .`
   - Run: `docker run -p 3003:3003 DRO`

### 6. Building the FEP (MERN App)

```
cd /Users/chrishughes/Projects/PDS/FEP
```

1. **Open the Implementation Guide**:
   - Open `IMPLEMENTATION_GUIDE.md` to understand the requirements and implementation steps
   
2. **Set up the backend**:
   - Prompt: "Implement the Express backend for the MERN app based on the implementation guide"
   
3. **Create user authentication**:
   - Prompt: "Implement the JWT-based authentication system for the MERN app"
   
4. **Implement PDS integration**:
   - Prompt: "Create the PDS integration with OAuth authorization flow"
   
5. **Set up credential verification**:
   - Prompt: "Implement the credential verification using the VC Verifier service"
   
6. **Create the frontend**:
   - Prompt: "Implement the React frontend for the MERN app"
   
7. **Implement GOV.UK compliant UI**:
   - Prompt: "Create a GOV.UK Design System compliant user interface for the MERN app, including registration, login, PDS connection, and benefit application screens"
   
8. **Implement benefit application management**:
   - Prompt: "Create the benefit application management functionality"
   
9. **Test the implementation**:
   - Prompt: "Create comprehensive tests for the MERN app, including all user flows and integration tests"
   
10. **Build and run the service**:
    - Run: `docker build -t FEP .`
    - Run: `docker run -p 3004:3004 FEP`

## Running the Complete System

After building all services, run the complete system using Docker Compose:

```
cd /Users/chrishughes/Projects/PDS
docker-compose up -d
```

This will start all services in the correct order with the necessary environment variables for integration.

## Testing the System

1. **Create a user in the Solid PDS**:
   - Go to `http://localhost:3000/register`
   - Register a new user and get a WebID

2. **Create a user in the DRO**:
   - Go to `http://localhost:3003/register`
   - Register with the same email and link your WebID

3. **Issue a credential**:
   - Log in to the DRO
   - Request a birth certificate
   - Authorize the DRO to store it in your PDS

4. **Use the credential in the MERN app**:
   - Go to `http://localhost:3004`
   - Register and log in
   - Connect your PDS
   - Start a new benefit application
   - Use your credentials to fill in the application

## Troubleshooting

1. **Service won't start**:
   - Check the logs: `docker logs [container-name]`
   - Verify environment variables in docker-compose.yml
   - Ensure required services are running

2. **Services can't communicate**:
   - Check that services are registered with the API Registry
   - Verify network settings in docker-compose.yml
   - Check service URLs in environment variables

3. **Authentication failures**:
   - Verify JWT configuration is consistent across services
   - Check OAuth client registration
   - Validate token expiration and refresh logic

4. **DID resolution fails**:
   - Check the DID Registry is running and accessible
   - Verify did:web configuration
   - Check domain name resolution in /etc/hosts

## Conclusion

Following this guide, you've built a complete microservices system with a Solid PDS, DID Registry, VC Verifier, Test VC Creator (DRO), and MERN App integration. The system demonstrates how to manage verifiable credentials in a user-controlled personal data store while enabling third-party services to issue and verify those credentials.

All services are fully functional with production-ready code and GOV.UK Design System compliant user interfaces. There are no placeholders or incomplete implementations in any part of the system.

Remember to review the implementation guides for each service for detailed information about their functionality and implementation details.

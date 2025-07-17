# Building, Testing, and Deploying the PDS Microservices System
## A Guide for Copilot-Assisted Development

This document provides step-by-step instructions for building, testing, and deploying each microservice in our PDS system. It's designed for developers using GitHub Copilot to implement each service independently.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Development Principles](#development-principles)
3. [Build Order](#build-order)
4. [Working with Copilot](#working-with-copilot)
5. [Service-by-Service Guide](#service-by-service-guide)
6. [Testing](#testing)
7. [Deployment](#deployment)
8. [Troubleshooting](#troubleshooting)

## Prerequisites

Before starting development, ensure you have:

- [Git](https://git-scm.com/downloads) installed
- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) installed
- [Node.js](https://nodejs.org/) (v18+) installed
- Access to GitHub Copilot
- Your favorite code editor (VS Code recommended)
- Ability to modify /etc/hosts file (for local domain emulation)

## Development Principles

1. **Service Isolation**: Each service should be developed in isolation without direct access to other services' code.
2. **API-First Development**: Use the specifications in each service's `specifications/` folder to guide implementation.
3. **Test-Driven Development**: Write tests before implementing features.
4. **Container-Based**: Each service should run in its own Docker container.
5. **API Registry Integration**: All services must publish their API specifications to the API Registry.
6. **did:web Implementation**: Services use did:web for decentralized identifiers.

## Build Order

Develop services in this order to minimize dependencies:

1. **API Registry Service** - Enables other services to publish and discover APIs
2. **Solid PDS** - Core data storage service
3. **DRO** - Departmental Records Office emulation
4. **FEP** - Frontend Portal application

## Working with Copilot

### How to Instruct Copilot Effectively

When working with GitHub Copilot on each service, use these prompt patterns:

1. **Initial Context Setting**:
   ```
   I'm building the [service name] for a PDS microservices system. The API spec is in the specifications/ folder. This service is isolated and should only communicate with other services via their published APIs, which are available through the API Registry. I need to implement the API Registry integration as specified in specifications/api-registry-integration.md.
   ```

2. **Implementation Requests**:
   ```
   Implement the [specific functionality] based on the API specification in specifications/api-spec.md. Remember this service runs in isolation in its own Docker container.
   ```

3. **API Registry Integration**:
   ```
   Help me implement the code to publish this service's API specification to the API Registry service as described in specifications/api-registry-integration.md.
   ```

4. **Testing Requests**:
   ```
   Write tests for [specific functionality] that validate the implementation against the API specification.
   ```

### Directing Copilot to API Registry Integration Files

When beginning work on a service, use these specific prompts to direct Copilot to use the API Registry integration requirements:

1. **Start with API Registry Requirements**:
   ```
   Before we start implementing the [service name], please review the specifications/api-registry-integration.md file to understand how this service should integrate with the API Registry.
   ```

2. **Request Implementation Based on Requirements**:
   ```
   Based on the requirements in specifications/api-registry-integration.md, help me implement the code to publish and/or consume API specifications for this service.
   ```

### What Copilot Needs to Know

Always provide these details to Copilot:
- The service name and purpose
- Location of API specifications (`specifications/` folder)
- Location of API Registry integration requirements (`specifications/api-registry-integration.md`)
- Reminder about service isolation
- Information about did:web implementation requirements
- Authentication/authorization patterns for the service

## Service-by-Service Guide

### 1. API Registry Service

**Goal**: Implement a service that stores and serves API specifications.

1. **Navigate to the service directory**:
   ```bash
   cd api-registry
   ```

2. **Review specifications**:
   ```bash
   cat specifications/api-spec.md
   ```

3. **Implement with Copilot**:
   - Prompt: "I'm implementing the API Registry service based on specifications/api-spec.md. Create the core server implementation."
   - Have Copilot implement each endpoint in the spec
   - Focus on storage, validation, and retrieval of API specs

4. **Test**:
   ```bash
   npm test
   ```

5. **Build container**:
   ```bash
   docker build -t api-registry .
   ```

### 2. Solid PDS

**Goal**: Set up the Solid Personal Data Store.

1. **Navigate to the service directory**:
   ```bash
   cd solid-pds
   ```

2. **Review specifications**:
   ```bash
   cat specifications/api-spec.md
   cat specifications/api-registry-integration.md
   ```

3. **Implement with Copilot**:
   - Prompt: "Before we start implementing the Solid PDS, please review the specifications/api-registry-integration.md file to understand how this service should integrate with the API Registry."
   - Next prompt: "I'm configuring a Solid Community Server as a Personal Data Store according to specifications/api-spec.md. Help me create the necessary configuration files."

4. **Test against Solid specifications**

5. **Publish API spec to Registry**:
   - Prompt: "Based on the requirements in specifications/api-registry-integration.md, help me implement the code to publish this service's API specification to the API Registry."

### 3. DRO

**Goal**: Implement a Departmental Records Office emulator that issues verifiable credentials.

1. **Navigate to the service directory**:
   ```bash
   cd DRO
   ```

2. **Review specifications**:
   ```bash
   cat specifications/api-spec.md
   cat specifications/api-registry-integration.md
   ```

3. **Implement with Copilot**:
   - Prompt: "I'm implementing a DRO service that emulates a Departmental Records Office. It needs to issue birth and marriage certificates as verifiable credentials using did:web, have its own user authentication system, and store credentials in a user's PDS."
   - Next prompt: "Help me implement the did:web functionality including the .well-known endpoint for DID document resolution."
   - Next prompt: "Let's implement the user registration and authentication system for the DRO."
   - Next prompt: "Now, I need to implement the credential issuance functionality for birth and marriage certificates using did:web signatures."
   - Final prompt: "Help me implement the PDS integration to store issued credentials in the user's pod."

4. **Test the implementation**:
   - Write tests for user authentication
   - Write tests for did:web implementation
   - Write tests for credential issuance
   - Write tests for PDS integration

5. **Publish API spec to Registry**:
   - Prompt: "Help me implement the code to publish this service's API specification to the API Registry according to specifications/api-registry-integration.md."

### 4. FEP

**Goal**: Create a Frontend Portal application to integrate with the PDS.

1. **Navigate to the service directory**:
   ```bash
   cd FEP
   ```

2. **Review specifications**:
   ```bash
   cat specifications/api-spec.md
   cat specifications/api-registry-integration.md
   ```

3. **Implement with Copilot**:
   - Prompt: "I'm creating a Frontend Portal application to integrate with a Solid PDS. The application needs to register as a client with the PDS, handle OAuth-style authorization for one-time permission, and access VCs stored in the user's pod."
   - Next prompt: "Let's implement the client registration with the Solid PDS."
   - Next prompt: "Now, help me implement the OAuth authorization flow with token management."
   - Next prompt: "I need to implement the VC retrieval and verification functionality using did:web resolution."
   - Final prompt: "Let's create a clean API that can be easily integrated into the application."

4. **Test the implementation**:
   - Write tests for PDS client registration
   - Write tests for OAuth flow
   - Write tests for VC retrieval and verification
   - Write tests for the integration API

5. **Publish API spec to Registry**:
   - Prompt: "Help me implement the code to publish this service's API specification to the API Registry according to specifications/api-registry-integration.md."

## Testing

### Individual Service Testing

For each service:

1. **Unit Tests**:
   ```bash
   cd [service-directory]
   npm test
   ```

2. **API Conformance Testing**:
   - Use the API Registry to validate implementations against specifications
   - Prompt: "Write a test script that validates this service's API implementation against the specification in the API Registry."

5. **Publish API spec to Registry**:
   - Prompt: "Based on the requirements in specifications/api-registry-integration.md, help me implement the code to publish this service's API specification to the API Registry."

### 3. DID Registry Service

And so on for each service... (details similar to above)

## Testing

### Individual Service Testing

For each service:

1. **Unit Tests**:
   ```bash
   cd [service-directory]
   npm test
   ```

2. **API Conformance Testing**:
   - Use the API Registry to validate implementations against specifications
   - Prompt: "Write a test script that validates this service's API implementation against the specification in the API Registry."

### Integration Testing

Once all services are implemented:

1. **Start the system**:
   ```bash
   docker-compose up -d
   ```

2. **Test end-to-end flows**:
   - DRO credential issuance flow
   - FEP credential retrieval flow
   - did:web resolution flow

3. **Validate against requirements**:
   - Check each service's compliance with its API spec
   - Verify integration points work correctly
   - Confirm authentication flows operate as expected

## Deployment

### Local Deployment

1. **Build all containers**:
   ```bash
   docker-compose build
   ```

2. **Start the system**:
   ```bash
   docker-compose up -d
   ```

3. **Verify all services are running**:
   ```bash
   docker-compose ps
   ```

4. **Access the services**:
   - API Registry: http://localhost:3005
   - Solid PDS: https://pds.local
   - DRO Service: https://dro.gov.uk.local
   - FEP App: https://fep.gov.uk.local

### Production Deployment Considerations

For production deployment, consider:

1. **Security hardening**:
   - Use proper SSL certificates
   - Implement proper authentication mechanisms
   - Secure container images

2. **Scaling**:
   - Configure appropriate resource limits
   - Consider containerized deployment to Kubernetes
   - Implement service monitoring

## Troubleshooting

### Common Issues

1. **Service fails to start**:
   - Check logs: `docker-compose logs [service-name]`
   - Verify environment variables in docker-compose.yml
   - Check for port conflicts

2. **Services can't communicate**:
   - Verify API Registry is running
   - Check network configuration in docker-compose.yml
   - Ensure services are publishing specs correctly

3. **API Registry integration issues**:
   - Verify API_REGISTRY_URL is set correctly
   - Check API publishing code
   - Verify API specs are valid OpenAPI

4. **did:web resolution issues**:
   - Check local domain configuration in /etc/hosts
   - Verify nginx configuration
   - Ensure .well-known endpoints are accessible

### Getting Help

If you encounter issues:

1. Check the service specifications
2. Review the API Registry logs
3. Consult the service-specific README
4. Check for errors in nginx logs for domain resolution issues

### Publishing an API Specification

Every service should publish its API specification to the API Registry during startup. Each service has detailed implementation requirements in its `specifications/api-registry-integration.md` file. Here's a general pattern:

```javascript
// Example code to publish API spec to the registry
const fs = require('fs');
const axios = require('axios');

async function publishApiSpec() {
  try {
    const apiSpec = JSON.parse(fs.readFileSync('./specifications/api-spec.json', 'utf8'));
    
    await axios.post('http://api-registry:3005/specs', {
      serviceName: process.env.SERVICE_NAME,
      version: process.env.SERVICE_VERSION,
      specification: apiSpec,
      description: 'API specification for ' + process.env.SERVICE_NAME
    }, {
      headers: {
        'Content-Type': 'application/json',
        'X-API-Key': process.env.API_REGISTRY_KEY
      }
    });
    
    console.log('API specification published successfully');
  } catch (error) {
    console.error('Failed to publish API specification:', error.message);
  }
}

// Call this function during service startup
publishApiSpec();
```

### Consuming API Specifications

Services can fetch other services' API specifications as needed, following the specific guidelines in their respective `api-registry-integration.md` files:

```javascript
// Example code to fetch another service's API spec
const axios = require('axios');

async function getServiceApiSpec(serviceName) {
  try {
    const response = await axios.get(`http://api-registry:3005/specs/${serviceName}/latest`);
    return response.data;
  } catch (error) {
    console.error(`Failed to fetch API spec for ${serviceName}:`, error.message);
    return null;
  }
}
```

## Troubleshooting

### Common Issues

1. **Services can't communicate**:
   - Check Docker network configuration
   - Verify service names and ports in requests

2. **API specification validation fails**:
   - Compare implementation with specification
   - Check for schema errors in the API specification

3. **Authentication fails**:
   - Verify API keys are correctly set in environment variables
   - Check authentication headers

### Getting Help

If you encounter issues:

1. Check service logs:
   ```bash
   docker-compose logs [service-name]
   ```

2. Validate service is running:
   ```bash
   docker-compose ps
   ```

3. Test service connectivity:
   ```bash
   docker-compose exec [service-name] curl -v http://[other-service]:[port]/health
   ```

---

Remember: The key to successful development with Copilot is providing clear context about the service's responsibilities and its interactions with other services through well-defined APIs.

# How to Use the API Registry Service

## 1. Publish Your API Specification

Send a POST request to `http://api-registry:3005/specs` with your OpenAPI spec, service name, and version. Include the API key in the `X-API-Key` header.

**Example (Node.js):**
```js
const fs = require('fs');
const axios = require('axios');

async function publishApiSpec() {
  const apiSpec = JSON.parse(fs.readFileSync('./specifications/api-spec.json', 'utf8'));
  await axios.post('http://api-registry:3005/specs', {
    serviceName: process.env.SERVICE_NAME,
    version: process.env.SERVICE_VERSION,
    specification: apiSpec,
    description: 'API specification for ' + process.env.SERVICE_NAME
  }, {
    headers: {
      'Content-Type': 'application/json',
      'X-API-Key': process.env.API_REGISTRY_KEY
    }
  });
}
```

## 2. Retrieve API Specifications

- To get a specific version: `GET http://api-registry:3005/specs/{serviceName}/{version}`
- To get the latest version: `GET http://api-registry:3005/specs/{serviceName}/latest`

**Example:**
```js
const axios = require('axios');
async function getServiceApiSpec(serviceName) {
  const response = await axios.get(`http://api-registry:3005/specs/${serviceName}/latest`);
  return response.data;
}
```

## 3. View Interactive API Documentation

Visit `http://api-registry:3005/ui/{serviceName}/{version}` in your browser.

## 4. API Registry’s Own API Docs

Visit `http://api-registry:3005/api-docs` for documentation.

## 5. Environment Variables Needed

- `API_REGISTRY_KEY` (for authentication)
- `SERVICE_NAME` and `SERVICE_VERSION` (for publishing)

---

Share this file with developers of other services to ensure proper integration with the API Registry.



*********** Adendum - SOLID PDS is now built and this is details *********
Service Endpoints Available:
Solid PDS Server: http://localhost:3000/
OpenID Configuration: http://localhost:3000/.well-known/openid-configuration
Client Registration: http://localhost:3000/idp/register
Token Endpoint: http://localhost:3000/idp/token
User Info: http://localhost:3000/idp/userinfo
API Registry Spec: http://localhost:3005/specs/solid-pds/1.0.0
API Documentation: http://localhost:3005/ui/solid-pds/1.0.0
🔧 Configuration Details:
Service Name: solid-pds
Version: 1.0.0
API Key: your-api-key-here
Storage: File-based in data directory
Authentication: OpenID Connect with WebID support
Authorization: WebACL (Web Access Control)
The Solid PDS is now ready to serve as a fully functional Personal Data Store with Solid Protocol compliance and is properly registered in the API Registry for service discovery!

*********** Adendum - API Registry is now built and this is details *********
The API Registry container is now running and available on port 3005.
You can proceed with development and integration for other services.

what is url and key to use it?

The API Registry service is running at:
URL: http://localhost:3005

To publish API specifications, use the following header for authentication:
Header: X-API-Key
Value: your-api-key-here

You can set the API key in your .env file as API_KEY=your-api-key-here.
Share this key with other services so they can publish their specs.


*********** Adendum - DID Registry is now built and this is details *********

Here’s a quick summary for your overall spec:

How Other Services Can Connect to the DID Registry via API Registry
Discover the DID Registry API

Fetch the OpenAPI specification from the API Registry:

GET http://localhost:3005/specs/did-registry/latest
Include header: X-API-Key: your-api-key-here
Use the Specification

Parse the OpenAPI spec to understand available endpoints, request/response formats, and authentication requirements.
Call DID Registry Endpoints

Example endpoints:
List DIDs: GET http://localhost:3001/dids
Get DID Document: GET http://localhost:3001/dids/{did}
Register DID: POST http://localhost:3001/dids
Use the details from the spec for request formatting.
Authentication

If required, include the API key in requests using the header:

X-API-Key: your-api-key-here
Documentation

This enables any service to discover, integrate, and interact with the DID Registry using the API Registry as a central source of truth.5. Documentation

This enables any service to discover, integrate, and interact with the DID Registry using the API Registry as a central source of truth
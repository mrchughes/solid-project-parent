# Building, Testing, and Deploying the Solid Microservices System
## An Idiot's Guide for Copilot-Assisted Development

This document provides step-by-step instructions for building, testing, and deploying each microservice in our Solid-based system. It's designed for developers using GitHub Copilot to implement each service independently.

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
- [Node.js](https://nodejs.org/) (v16+) installed
- Access to GitHub Copilot
- Your favorite code editor (VS Code recommended)

## Development Principles

1. **Service Isolation**: Each service should be developed in isolation without direct access to other services' code.
2. **API-First Development**: Use the specifications in each service's `specifications/` folder to guide implementation.
3. **Test-Driven Development**: Write tests before implementing features.
4. **Container-Based**: Each service should run in its own Docker container.
5. **API Registry Integration**: All services must publish their API specifications to the API Registry.

## Build Order

Develop services in this order to minimize dependencies:

1. **API Registry Service** - Enables other services to publish and discover APIs
2. **Solid PDS** - Core data storage service
3. **DID Registry** - Identity management
4. **VC Verifier** - Verifies credentials
5. **Test VC Creator** - Generates test credentials
6. **React UI** - User interface
7. **MERN App** - Example application

## Working with Copilot

### How to Instruct Copilot Effectively

When working with GitHub Copilot on each service, use these prompt patterns:

1. **Initial Context Setting**:
   ```
   I'm building the [service name] for a Solid-based microservices system. The API spec is in the specifications/ folder. This service is isolated and should only communicate with other services via their published APIs, which are available through the API Registry. There is a detailed API Registry integration specification in specifications/api-registry-integration.md that I need to follow.
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

3. **During Implementation Reviews**:
   ```
   Check if our implementation complies with the API Registry integration requirements specified in specifications/api-registry-integration.md.
   ```

### What Copilot Needs to Know

Always provide these details to Copilot:
- The service name and purpose
- Location of API specifications (`specifications/` folder)
- Location of API Registry integration requirements (`specifications/api-registry-integration.md`)
- Reminder about service isolation
- Information about environment variables from docker-compose.yml

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
   cd solid-microservices
   docker-compose up -d
   ```

2. **Test service interactions**:
   - Create a test script that exercises the full workflow
   - Verify data flows correctly between services

## Deployment

### Local Deployment

```bash
cd solid-microservices
docker-compose up -d
```

### Production Deployment

1. **Prepare environment**:
   - Set up proper DNS
   - Configure TLS certificates
   - Set secure environment variables

2. **Deploy with Docker Compose**:
   ```bash
   docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
   ```

3. **Verify deployment**:
   - Check service health endpoints
   - Run smoke tests against the deployed system

## API Registry Integration Details

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
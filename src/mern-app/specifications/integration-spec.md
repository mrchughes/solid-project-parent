# MERN App Integration Specification

## Overview

The MERN Stack Benefit Application integrates with the Solid PDS and VC Verifier to authenticate users via WebID and verify their credentials. This integration allows the existing application to use verified data from Verifiable Credentials in its benefit processing workflow.

## Features

- **WebID Authentication**: Allow users to authenticate using their WebID
- **Credential Retrieval**: Retrieve Verifiable Credentials from the user's Solid Pod
- **Credential Verification**: Verify the authenticity and integrity of credentials
- **Data Integration**: Integrate verified data into the benefit application workflow
- **Benefit Processing**: Use verified data to process benefit applications

## Integration Components

### Authentication Integration

- **WebID Login**: Integration with Solid OIDC for WebID-based authentication
- **Session Management**: Management of authenticated sessions
- **Access Control**: Authorization based on authenticated identity

### Credential Integration

- **Credential Fetcher**: Component to fetch credentials from a Solid Pod
- **Credential Verifier**: Integration with the VC Verifier service
- **Data Extractor**: Component to extract verified data from credentials

### Workflow Integration

- **Evidence Collection**: Use VCs as evidence in benefit applications
- **Automated Verification**: Automated verification of submitted evidence
- **Decision Support**: Use verified data to support benefit decisions

## Implementation Details

The MERN App integration is implemented as extensions to the existing MERN (MongoDB, Express.js, React, Node.js) application. It adds new routes, components, and services to support the Solid and VC integration.

### Technology Stack

- MongoDB for data storage
- Express.js for the backend API
- React for the frontend UI
- Node.js for the runtime environment
- @inrupt/solid-client for Solid interactions
- Custom modules for VC verification

### Authentication Flow

The authentication flow extends the existing authentication system with Solid OIDC:

1. User clicks "Login with WebID" and is redirected to the Solid Identity Provider
2. User authenticates with the Identity Provider
3. User is redirected back to the application with an authorization code
4. Application exchanges the code for an access token
5. Application creates or updates the user in the local database
6. Application issues a session token for the authenticated user

## API Endpoints

### Authentication

- `POST /auth/webid/login` - Initiate WebID login
- `GET /auth/webid/callback` - Handle WebID login callback
- `GET /auth/session` - Get current session information

### Credential Management

- `GET /vc/fetch-from-pod` - Fetch credentials from a Solid Pod
- `POST /vc/verify` - Verify a credential
- `GET /vc/extract-data` - Extract data from a verified credential

## Deployment

The MERN App is deployed as a Docker container. It exposes the API and UI on port 3005 and communicates with the Solid PDS and VC Verifier services.

## Dependencies

- MongoDB
- Express.js
- React
- Node.js
- @inrupt/solid-client
- Custom modules for VC verification

## Integration Points

The MERN App interacts with the following services:

- **Solid PDS**: For user authentication and credential retrieval
- **VC Verifier**: For verifying the authenticity and integrity of credentials

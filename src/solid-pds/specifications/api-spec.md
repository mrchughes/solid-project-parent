# Solid PDS Service Specification

## Overview

The Solid PDS (Personal Data Store) Service is based on the Community Solid Server and provides a standards-compliant Solid server implementation. It hosts user pods (personal data stores) and WebIDs that serve as the foundation for decentralized identity and data management in the system.

## Features

- **User Registration and WebID Creation**: Allows users to register and obtain a WebID, which serves as their digital identity
- **Pod Hosting**: Creates and manages personal data pods for each user
- **Authentication**: Implements Solid OIDC for authentication and authorization
- **Access Control**: Allows users to control access to their data using Web Access Control (WAC)
- **RESTful API**: Provides a RESTful API for interacting with pods and resources

## API Endpoints

The Solid PDS implements the Solid Protocol, which includes the following key endpoints:

### Identity and Authentication

- `GET /.well-known/openid-configuration` - OpenID Connect configuration
- `POST /idp/register` - Register a new client
- `POST /idp/token` - Get an access token
- `GET /idp/userinfo` - Get information about the authenticated user

### Pod Management

- `POST /pods` - Create a new pod
- `GET /pods/:podName` - Get information about a pod
- `DELETE /pods/:podName` - Delete a pod

### Resource Management

- `GET /:path*` - Read a resource or container
- `HEAD /:path*` - Check if a resource exists
- `POST /:path*` - Create a resource
- `PUT /:path*` - Update a resource
- `PATCH /:path*` - Partially update a resource
- `DELETE /:path*` - Delete a resource

## Configuration

The Community Solid Server can be configured using a configuration file or environment variables. Key configuration options include:

- `CSS_PORT` - The port the server listens on
- `CSS_CONFIG` - Path to a configuration file
- `CSS_ROOT_FILE_PATH` - Root file path for the server
- `CSS_SPARQL_ENDPOINT` - SPARQL endpoint for querying data

## Deployment

The Solid PDS service is deployed as a Docker container using the official `solidproject/community-solid-server` image. The configuration and data are persisted in volumes.

## Dependencies

- Community Solid Server
- Node.js

## Integration Points

The Solid PDS interacts with the following services:

- **Test VC Creator Service**: The VC Creator service stores Verifiable Credentials in the user's pod
- **VC Verifier Service**: The VC Verifier service retrieves Verifiable Credentials from the user's pod
- **React UI**: The UI allows users to register, login, and manage their pod
- **MERN App**: The MERN app authenticates against the PDS and retrieves credentials from the user's pod

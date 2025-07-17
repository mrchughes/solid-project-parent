# Service Specification Update Plan

This document outlines the plan for updating the API specifications of each service to align with our new architecture. Each service needs to have its API specification in OpenAPI format and instructions for publishing to the API Registry.

## 1. Solid PDS Service

**Specification Updates:**
- No major changes needed, as we're using the standard Solid PDS
- Add documentation for did:web resolution endpoints
- Update API Registry integration document to reflect the new architecture

## 2. Test VC Creator (DRO) Service

**New API Endpoints to Document:**
- User registration and authentication endpoints
- did:web document endpoint (/.well-known/did.json)
- Birth certificate issuance endpoint
- Marriage certificate issuance endpoint
- PDS connection and credential storage endpoints

**Updates to API Registry Integration:**
- Update to reflect direct integration with API Registry
- Remove references to DID Registry

## 3. MERN App Extension

**New API Endpoints to Document:**
- PDS client registration endpoints
- OAuth authorization endpoints
- Token management endpoints
- VC retrieval and verification endpoints
- did:web resolution endpoints

**Updates to API Registry Integration:**
- Document discovery of DRO and PDS APIs through API Registry
- Specify API publishing requirements

## 4. API Registry

**No major changes needed** as this service remains largely the same.

## Implementation Steps

For each service:

1. Update the OpenAPI specification in `specifications/api-spec.json` or `specifications/api-spec.yaml`
2. Update the API Registry integration document in `specifications/api-registry-integration.md`
3. Update the implementation to match the new specifications
4. Add tests to validate compliance with the specifications
5. Ensure proper publishing to the API Registry

## Timeframe

Each service specification update should be completed before implementation begins, following the build order specified in the BUILD_AND_DEPLOY_GUIDE.md document.

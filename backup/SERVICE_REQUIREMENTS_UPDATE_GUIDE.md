# Updating Service Requirements for API Registry Integration

This document outlines how to update each service's requirements documentation to include API Registry integration. Follow these steps for each service in the system.

## Status Update

**COMPLETED**: All services now have detailed API Registry integration requirements in their respective `specifications/api-registry-integration.md` files.

When instructing Copilot to build a service, direct it to review this file first:

```
Before we start implementing the [service name], please review the specifications/api-registry-integration.md file to understand how this service should integrate with the API Registry.
```

## Summary of API Registry Integration Files

Each service now has a dedicated integration specification file:

1. `/solid-pds/specifications/api-registry-integration.md`
2. `/did-registry/specifications/api-registry-integration.md`
3. `/test-vc-creator/specifications/api-registry-integration.md` 
4. `/vc-verifier/specifications/api-registry-integration.md`
5. `/vc-issuer/specifications/api-registry-integration.md`
6. `/react-ui/specifications/api-registry-integration.md`
7. `/mern-app/specifications/api-registry-integration.md`

These files contain detailed, service-specific requirements for:
- When to publish/consume API specifications
- What data to publish/consume
- How to authenticate with the API Registry
- Implementation guidelines with code examples
- Testing requirements
- Documentation guidelines

## Service-Specific Additions

### Solid PDS

```markdown
### API Registry Integration for Solid PDS

The Solid PDS service should publish its RESTful API specification describing WebID authentication, pod storage operations, and access control mechanisms.
```

### DID Registry Service

```markdown
### API Registry Integration for DID Registry

The DID Registry service must publish comprehensive API specifications for DID creation, resolution, and update operations. This is particularly important as other services will rely on these operations for identity verification.
```

### Test VC Creator

```markdown
### API Registry Integration for Test VC Creator

The Test VC Creator must publish specifications for all credential creation endpoints, including required input formats and validation rules. It must also consume the DID Registry API specification to ensure compatibility.
```

### VC Verifier

```markdown
### API Registry Integration for VC Verifier

The VC Verifier service must publish its verification API specification and consume both the DID Registry and Solid PDS specifications to ensure proper integration for verification operations.
```

### React UI

```markdown
### API Registry Integration for React UI

The React UI should consume API specifications from all backend services it interacts with to enable proper client-side validation and potentially generate API client code.
```

### MERN App

```markdown
### API Registry Integration for MERN App

The MERN App must publish its business logic API specification and consume specifications from the Solid PDS, DID Registry, and VC Verifier services to ensure proper integration.
```

## Implementation Checklist

For each service, ensure:

- [ ] Requirements document updated with API Registry integration section
- [ ] OpenAPI specification created/updated to reflect current API
- [ ] Code implemented to publish specification to API Registry
- [ ] Code implemented to consume other services' specifications (if needed)
- [ ] Tests added to verify successful publication
- [ ] Documentation updated to reflect API Registry integration

## Review Process

After updating each service's requirements:
1. Review for consistency across all services
2. Ensure all interdependencies are correctly documented
3. Verify that the requirements align with the overall system architecture
4. Update the service's README.md to mention API Registry integration

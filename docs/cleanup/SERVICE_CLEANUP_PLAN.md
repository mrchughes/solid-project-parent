# Service Cleanup Plan

Based on our revised architecture, some services are no longer required. This document outlines the plan for removing these services and cleaning up the repository.

## Services to Remove

1. **DID Registry Service**
   - No longer needed as we're using did:web directly
   - Documentation references should be updated
   - Any dependent code should be migrated to use did:web

2. **VC Verifier Service**
   - Functionality to be integrated into the MERN App Extension
   - Verification logic can be reused
   - API endpoints will be consolidated

3. **React UI Service**
   - Authentication and credential management now handled by DRO and MERN App
   - Any useful components can be migrated to the other services

## Cleanup Steps

1. **Documentation Updates**
   - Remove references to removed services from README.md
   - Update BUILD_AND_DEPLOY_GUIDE.md to reflect new architecture
   - Update docker-compose.yml to remove unused services

2. **API Registry Cleanup**
   - Remove API specifications for unused services
   - Update other services to not depend on removed services

3. **Code Migration**
   - Identify useful code in removed services
   - Migrate necessary functionality to remaining services
   - Document migration in relevant service READMEs

## Implementation Timeline

The cleanup should be performed after the updated specifications are finalized but before implementation of the new features begins.

## Validation

After cleanup, ensure:
- Docker Compose file only references required services
- No documentation refers to removed services
- All remaining services function without dependencies on removed services

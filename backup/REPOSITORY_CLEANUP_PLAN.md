# Repository Cleanup Plan

This document outlines the cleanup plan for the PDS microservices system. The goal is to ensure all modules are discrete microservices that can be built independently according to specifications, removing any unnecessary files or modules.

## Required Microservices

Based on the specifications and implementation guides, the following microservices are required:

1. **API Registry** - Central registry for service API discovery and documentation
2. **DID Registry** - Registry for did:web identifiers and documents
3. **Solid PDS** - Personal Data Store based on Community Solid Server
4. **VC Verifier** - Service for verifying credentials from the PDS
5. **Test VC Creator (DRO)** - Service for issuing credentials to the PDS (acts as DRO)
6. **MERN App** - Benefits application with PDS integration

## Unnecessary Modules/Files to Remove

The following modules or files should be removed as they are not required for the current architecture:

1. **vc-issuer/** - Redundant as Test VC Creator (DRO) handles credential issuance
2. **react-ui/** - Redundant as UI is integrated into each service that requires it (PDS, DRO, MERN App)
3. **solid-microservices/** - Redundant as each microservice is its own independent module
4. **backup/** - Not required for the production system
5. **SERVICE_CLEANUP_PLAN.md** - Can be replaced with this document
6. **SPECIFICATION_UPDATE_PLAN.md** - Should be consolidated into a single planning document
7. **.DS_Store** - macOS system file that should not be in the repository

## Updates to .gitmodules

The .gitmodules file should be updated to remove references to the unnecessary modules:

1. Remove `react-ui` submodule
2. Remove `solid-microservices` submodule
3. Remove `vc-issuer` submodule

## Updates to docker-compose.yml

The docker-compose.yml file already includes the required services. However, we should ensure it's properly configured for all required services:

1. Add the `did-registry` service
2. Add the `vc-verifier` service
3. Remove any references to removed services

## Updates to setup_submodules.sh

The setup_submodules.sh script should be updated to remove references to the unnecessary modules:

1. Remove `react-ui` from the MODULES array
2. Remove `solid-microservices` from the MODULES array
3. Remove `vc-issuer` from the MODULES array

## Cleanup Actions

1. **Remove Unnecessary Modules**:
   ```bash
   git submodule deinit -f react-ui
   git rm -f react-ui
   rm -rf .git/modules/react-ui

   git submodule deinit -f solid-microservices
   git rm -f solid-microservices
   rm -rf .git/modules/solid-microservices

   git submodule deinit -f vc-issuer
   git rm -f vc-issuer
   rm -rf .git/modules/vc-issuer
   ```

2. **Remove Unnecessary Files**:
   ```bash
   rm -f .DS_Store
   rm -f SERVICE_CLEANUP_PLAN.md
   rm -f SPECIFICATION_UPDATE_PLAN.md
   rm -rf backup
   ```

3. **Update Configuration Files**:
   - Update .gitmodules (as described above)
   - Update setup_submodules.sh (as described above)
   - Update docker-compose.yml to include all required services

4. **Verify Service Requirements**:
   - Ensure all required services have implementation guides
   - Verify integration points between services
   - Check that UI requirements are specified for services that need them

## Validation

After cleanup, the repository should have the following structure:

```
PDS/
├── docker-compose.yml          # Container orchestration
├── BUILDING_GUIDE.md           # Guide for building each service
├── IMPLEMENTATION_VERIFICATION.md # Verification of implementation guides
├── README.md                   # Project overview
├── Requirements/               # Project requirements
├── scripts/                    # Utility scripts
├── setup_submodules.sh         # Updated submodule setup script
├── api-registry/               # API Registry service
│   └── specifications/         # API specifications
├── did-registry/               # DID Registry service
│   └── specifications/         # API specifications
├── solid-pds/                  # Solid PDS service
│   └── specifications/         # API specifications
├── test-vc-creator/            # DRO service for issuing credentials
│   └── specifications/         # API specifications
├── vc-verifier/                # VC Verifier service
│   └── specifications/         # API specifications
└── mern-app/                   # MERN app for PDS integration
    └── specifications/         # API specifications
```

Each service should be a discrete microservice that can be built independently according to its specification. The docker-compose.yml file should include all required services to run the complete system.

# PDS System Documentation

This directory contains all the documentation for the PDS (Personal Data Store) microservices system.

## Requirements

- **requirements/PDS_Specification_1.0a.txt** - Official PDS System Specification v1.0a

## Core Documentation

- **UPDATED_ARCHITECTURE.md** - Current architecture with did:web implementation
- **ARCHITECTURE_UPDATE_SUMMARY.md** - Summary of changes to remove DID Registry
- **DID_MIGRATION_GUIDE.md** - Guide for implementing did:web directly in services

## Implementation Guides

- **BUILDING_GUIDE.md** - Step-by-step guide for building each service
- **BUILD_AND_DEPLOY_GUIDE.md** - Detailed build and deployment instructions
- **IMPLEMENTATION_VERIFICATION.md** - Criteria for verifying implementation completeness

## Best Practices

- **MICROSERVICES_BEST_PRACTICES.md** - Guidelines for loose coupling and high cohesion
- **SERVICE_IMPLEMENTATION_CHECKLIST.md** - Checklist for implementing each service

## Service-Specific Documentation

Each service also has its own implementation guide in its respective directory:

- `/api-registry/README.md` - API Registry documentation
- `/solid-pds/README.md` - Solid PDS documentation
- `/test-vc-creator/README.md` - Test VC Creator (DRO) documentation
- `/vc-verifier/README.md` - VC Verifier documentation
- `/mern-app/README.md` - MERN App documentation

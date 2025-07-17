# Standards Implementation Guide

This document explains how to implement the standardization documents that are included in each service's `docs` directory.

## Overview

Each service in the PDS microservices system includes copies of centralized standards documents to ensure consistency across the system, even when services are developed independently. These standards are:

1. **ERROR_HANDLING_STANDARDS.md** - Standard error handling format and codes
2. **DATA_MODELS.md** - Standardized data models across services
3. **GOVUK_DESIGN_SYSTEM_GUIDE.md** - UI implementation guidelines
4. **SERVICE_IMPLEMENTATION_CHECKLIST_V2.md** - Implementation verification checklist

## How to Use These Standards

### Error Handling Standards

1. Implement error middleware in your service that follows the format defined in `docs/ERROR_HANDLING_STANDARDS.md`
2. Use the standard error codes for consistent error reporting
3. Log errors according to the recommended patterns
4. Test error responses to ensure they match the standard format

Example Express error handler:
```javascript
app.use((err, req, res, next) => {
  const statusCode = err.statusCode || 500;
  const errorCode = err.code || 'INTERNAL_SERVER_ERROR';
  const message = err.message || 'An unexpected error occurred';
  
  logger.error(`Error: ${errorCode} - ${message}`, {
    error: err,
    requestId: req.id,
    path: req.path,
    method: req.method
  });
  
  res.status(statusCode).json({
    error: {
      code: errorCode,
      message: message,
      details: err.details || undefined
    }
  });
});
```

### Data Models

1. Implement data models according to the definitions in `docs/DATA_MODELS.md`
2. Use the standard fields, types, and formats for all data
3. Validate data against these models using JSON Schema or similar
4. Maintain backward compatibility when evolving models

### GOV.UK Design System

For services with user interfaces:

1. Follow the guidelines in `docs/GOVUK_DESIGN_SYSTEM_GUIDE.md`
2. Use the recommended components and patterns
3. Ensure accessibility compliance
4. Test on various devices and screen sizes

### Implementation Checklist

Use `docs/SERVICE_IMPLEMENTATION_CHECKLIST_V2.md` to:

1. Verify your service implementation before submission
2. Track progress during development
3. Ensure all requirements are met
4. Document any exceptions or special considerations

## Integration with README-IMPLEMENTATION.md

Your service's `README-IMPLEMENTATION.md` should reference these standards documents where appropriate:

```markdown
## Error Handling

This service follows the standard error handling format defined in [Error Handling Standards](./docs/ERROR_HANDLING_STANDARDS.md).

## Data Models

Data models in this service adhere to the standards defined in [Data Models](./docs/DATA_MODELS.md).

## User Interface

The user interface follows the GOV.UK Design System as documented in [GOV.UK Design System Guide](./docs/GOVUK_DESIGN_SYSTEM_GUIDE.md).

## Implementation Verification

Use the [Service Implementation Checklist](./docs/SERVICE_IMPLEMENTATION_CHECKLIST_V2.md) to verify the implementation of this service.
```

## Standards Updates

If standards are updated in the central repository, they should be copied to each service using the `scripts/copy_standards.sh` script. When working on an isolated service, be sure to check if there are newer versions of the standards documents in the central repository.

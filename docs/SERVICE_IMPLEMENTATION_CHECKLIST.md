# Service Implementation Checklist

Use this checklist to ensure each service implementation follows the loose coupling and high cohesion principles.

## Service: [Service Name]

### Independent Building and Deployment

- [ ] Service has a clear README with build and run instructions
- [ ] Service can be built with only `npm install && npm start` (or equivalent)
- [ ] Service has its own Dockerfile for containerized deployment
- [ ] Service has a comprehensive test suite (`npm test`)
- [ ] Service contains all necessary code without external dependencies beyond npm packages

### API Registry Integration

- [ ] Service publishes its API specification to API Registry on startup
- [ ] Service discovers other services via the API Registry
- [ ] Service does not hardcode URLs to other services
- [ ] Service handles API Registry unavailability gracefully

### Service-Specific Requirements

#### For Test VC Creator (DRO)

- [ ] Implements did:web document at `/.well-known/did.json`
- [ ] Generates and securely stores cryptographic keys
- [ ] Signs credentials using its own keys without DID Registry dependency
- [ ] Implements GOV.UK style guide compliant UI

#### For VC Verifier

- [ ] Implements direct did:web resolution
- [ ] Verifies credentials without DID Registry dependency
- [ ] Implements GOV.UK style guide compliant UI

#### For MERN App

- [ ] Integrates with Solid PDS for data storage
- [ ] Uses VC Verifier for credential verification
- [ ] Implements did:web if needed for its own identity
- [ ] Implements GOV.UK style guide compliant UI

#### For Solid PDS

- [ ] Configures Community Solid Server properly
- [ ] Integrates with API Registry
- [ ] Implements proper WebID-OIDC authentication
- [ ] Implements proper data storage and access control

### Data Isolation

- [ ] Service owns and manages its own data
- [ ] Service does not directly access other services' databases
- [ ] Service exposes data only through well-defined APIs

### Error Handling and Resilience

- [ ] Service handles dependent service unavailability gracefully
- [ ] Service implements proper error handling and logging
- [ ] Service has health check endpoints
- [ ] Service returns appropriate HTTP status codes

### Documentation

- [ ] API is documented with OpenAPI specification
- [ ] README includes comprehensive setup instructions
- [ ] Code has proper comments and documentation
- [ ] Environment variables are documented with defaults

### Security

- [ ] Service validates all inputs
- [ ] Service implements proper authentication and authorization
- [ ] Service securely stores sensitive data (keys, credentials)
- [ ] Service follows security best practices

### UI Requirements (Where Applicable)

- [ ] UI follows GOV.UK Design System guidelines
- [ ] UI is fully functional with no placeholders
- [ ] UI is accessible and responsive
- [ ] UI handles errors gracefully with user-friendly messages

---

By completing this checklist for each service, you ensure that it adheres to the principles of loose coupling and high cohesion, making the entire system more maintainable, scalable, and resilient.

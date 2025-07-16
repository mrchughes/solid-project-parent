# DID Architecture Migration Guide

This guide explains how to migrate from the centralized DID Registry approach to the distributed did:web implementation in each service.

## Overview of Changes

The architecture has been updated to remove the central DID Registry service in favor of a distributed approach where each service implements the `did:web` method directly. Key changes include:

1. Removal of the DID Registry service
2. Direct did:web implementation in services that need DIDs
3. Direct DID resolution from source domains

## Migration Steps for Each Service

### Test VC Creator (DRO)

1. **Implement did:web Document Endpoint**:
   ```javascript
   // Create a route for serving the DID document
   app.get('/.well-known/did.json', (req, res) => {
     // Return the DID document with public keys
     res.json({
       "@context": ["https://www.w3.org/ns/did/v1"],
       "id": `did:web:${process.env.DRO_DOMAIN || 'dro.gov.uk.local'}`,
       "verificationMethod": [{
         "id": `did:web:${process.env.DRO_DOMAIN || 'dro.gov.uk.local'}#key-1`,
         "type": "Ed25519VerificationKey2020",
         "controller": `did:web:${process.env.DRO_DOMAIN || 'dro.gov.uk.local'}`,
         "publicKeyJwk": {
           // Your public key in JWK format
           "kty": "OKP",
           "crv": "Ed25519",
           "x": "your-base64-encoded-public-key"
         }
       }],
       "authentication": [
         `did:web:${process.env.DRO_DOMAIN || 'dro.gov.uk.local'}#key-1`
       ],
       "assertionMethod": [
         `did:web:${process.env.DRO_DOMAIN || 'dro.gov.uk.local'}#key-1`
       ]
     });
   });
   ```

2. **Implement Key Generation/Storage**:
   ```javascript
   const crypto = require('crypto');
   const fs = require('fs');
   
   function generateKeypair() {
     // Generate Ed25519 keypair
     const keypair = crypto.generateKeyPairSync('ed25519');
     
     // Export keys in proper format
     const publicKeyJwk = { /* export public key as JWK */ };
     const privateKeyJwk = { /* export private key as JWK */ };
     
     // Save keys securely
     fs.writeFileSync('./data/keys/public.json', JSON.stringify(publicKeyJwk));
     fs.writeFileSync('./data/keys/private.json', JSON.stringify(privateKeyJwk));
     
     return { publicKeyJwk, privateKeyJwk };
   }
   ```

3. **Implement Direct DID Resolution**:
   ```javascript
   async function resolveDid(did) {
     // Convert DID to URL
     // Example: did:web:dro.gov.uk.local -> https://dro.gov.uk.local/.well-known/did.json
     const didUrl = did.replace('did:web:', 'https://') + '/.well-known/did.json';
     
     // Fetch the DID document
     const response = await fetch(didUrl);
     if (!response.ok) {
       throw new Error(`Failed to resolve DID: ${did}`);
     }
     
     return response.json();
   }
   ```

4. **Update Credential Signing**:
   ```javascript
   async function signCredential(credential) {
     // Load private key
     const privateKeyJwk = JSON.parse(fs.readFileSync('./data/keys/private.json'));
     
     // Create a proof
     const proof = {
       type: "Ed25519Signature2020",
       created: new Date().toISOString(),
       verificationMethod: `did:web:${process.env.DRO_DOMAIN}#key-1`,
       proofPurpose: "assertionMethod",
       proofValue: "z..." // Sign using the private key
     };
     
     return { ...credential, proof };
   }
   ```

### VC Verifier

1. **Implement Direct DID Resolution** (similar to Test VC Creator)

2. **Update Credential Verification**:
   ```javascript
   async function verifyCredential(credential) {
     // Extract issuer DID
     const issuerDid = credential.issuer;
     
     // Resolve issuer DID document
     const didDocument = await resolveDid(issuerDid);
     
     // Get verification method
     const verificationMethod = didDocument.verificationMethod.find(
       vm => vm.id === credential.proof.verificationMethod
     );
     
     if (!verificationMethod) {
       throw new Error('Verification method not found in DID document');
     }
     
     // Verify using the public key from the DID document
     const publicKey = verificationMethod.publicKeyJwk;
     
     // Verify signature
     // ...verification logic using the public key
     
     return true; // or false if verification fails
   }
   ```

### MERN App

1. **Update to Use the VC Verifier**:
   ```javascript
   async function verifyCredentialWithVerifier(credential) {
     const response = await fetch(`${process.env.VC_VERIFIER_URL}/verify`, {
       method: 'POST',
       headers: {
         'Content-Type': 'application/json'
       },
       body: JSON.stringify({ credential })
     });
     
     if (!response.ok) {
       throw new Error('Verification failed');
     }
     
     return response.json();
   }
   ```

2. **Implement did:web Document Endpoint** (if needed, similar to Test VC Creator)

## Testing Your Implementation

After implementing the changes, test the following flows:

1. **DID Resolution**:
   - Test resolving a DID from another service
   - Ensure the DID document is properly formatted

2. **Credential Issuance and Verification**:
   - Test the full flow of credential issuance by the DRO
   - Test verification of the credential by the VC Verifier

3. **MERN App Integration**:
   - Test the MERN App's integration with the VC Verifier
   - Ensure the app can request and display verification results

## Common Issues and Solutions

1. **CORS Issues**: If you encounter CORS errors when resolving DIDs, ensure your services have proper CORS headers:
   ```javascript
   app.use((req, res, next) => {
     res.header('Access-Control-Allow-Origin', '*');
     res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
     next();
   });
   ```

2. **SSL Certificate Validation**: If using HTTPS with self-signed certificates:
   ```javascript
   const https = require('https');
   const agent = new https.Agent({
     rejectUnauthorized: process.env.NODE_ENV === 'production'
   });
   
   // Use the agent when fetching
   fetch(url, { agent });
   ```

3. **DID Resolution Failures**: If DID resolution fails, check:
   - The domain is correctly configured
   - The nginx routing is properly set up
   - The `/.well-known/did.json` endpoint is accessible

## Resources

- [did:web Method Specification](https://w3c-ccg.github.io/did-method-web/)
- [W3C Verifiable Credentials](https://www.w3.org/TR/vc-data-model/)
- [GOV.UK Design System](https://design-system.service.gov.uk/)

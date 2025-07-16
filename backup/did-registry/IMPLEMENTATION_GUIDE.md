# did-registry Implementation Guide

## Overview

This document provides implementation guidance for the DID Registry service in our microservices architecture. Your task is to implement a service that manages decentralized identifiers (DIDs) using the did:web method.

## Requirements

1. **DID Creation**: Generate and manage did:web identifiers
2. **DID Document Management**: Create, update, and retrieve DID documents
3. **API Registry Integration**: Register with the API Registry service
4. **Authentication**: Secure API endpoints with JWT authentication

## Implementation Steps

### 1. DID Management

Create a service to handle DID creation and management:

```javascript
// src/services/didService.js
const fs = require('fs/promises');
const path = require('path');
const { v4: uuidv4 } = require('uuid');

// Constants
const DATA_DIR = process.env.DATA_DIR || './data';
const DID_FILE = path.join(DATA_DIR, 'dids.json');

// Initialize the service
const initialize = async () => {
  try {
    // Ensure data directory exists
    await fs.mkdir(DATA_DIR, { recursive: true });
    
    // Check if DID file exists, create it if not
    try {
      await fs.access(DID_FILE);
    } catch (error) {
      // File doesn't exist, create it with empty array
      await fs.writeFile(DID_FILE, JSON.stringify([]));
    }
    
    console.log('DID Service initialized successfully');
  } catch (error) {
    console.error('Failed to initialize DID Service:', error);
    throw error;
  }
};

// Get all DIDs
const getAllDids = async () => {
  try {
    const data = await fs.readFile(DID_FILE, 'utf8');
    return JSON.parse(data);
  } catch (error) {
    console.error('Error reading DIDs:', error);
    throw error;
  }
};

// Get DID by ID
const getDidById = async (didId) => {
  try {
    const dids = await getAllDids();
    return dids.find(did => did.id === didId);
  } catch (error) {
    console.error(`Error getting DID ${didId}:`, error);
    throw error;
  }
};

// Create a new DID
const createDid = async (domain, path, controller, keyPair) => {
  try {
    // Format: did:web:domain[:port][/path]
    const didId = path 
      ? `did:web:${domain}:${path}`
      : `did:web:${domain}`;
    
    // Create DID document
    const didDocument = {
      '@context': [
        'https://www.w3.org/ns/did/v1',
        'https://w3id.org/security/suites/ed25519-2020/v1'
      ],
      id: didId,
      controller: controller || didId,
      verificationMethod: [
        {
          id: `${didId}#key-1`,
          type: 'Ed25519VerificationKey2020',
          controller: didId,
          publicKeyMultibase: keyPair.publicKeyMultibase
        }
      ],
      authentication: [
        `${didId}#key-1`
      ],
      assertionMethod: [
        `${didId}#key-1`
      ]
    };
    
    // Create DID record
    const didRecord = {
      id: didId,
      controller: controller || didId,
      domain,
      path: path || '',
      created: new Date().toISOString(),
      updated: new Date().toISOString(),
      document: didDocument,
      privateKeyMultibase: keyPair.privateKeyMultibase
    };
    
    // Add to DIDs storage
    const dids = await getAllDids();
    dids.push(didRecord);
    await fs.writeFile(DID_FILE, JSON.stringify(dids, null, 2));
    
    return didRecord;
  } catch (error) {
    console.error('Error creating DID:', error);
    throw error;
  }
};

// Update a DID document
const updateDidDocument = async (didId, updates) => {
  try {
    const dids = await getAllDids();
    const didIndex = dids.findIndex(did => did.id === didId);
    
    if (didIndex === -1) {
      throw new Error(`DID ${didId} not found`);
    }
    
    // Apply updates to DID document
    dids[didIndex].document = {
      ...dids[didIndex].document,
      ...updates
    };
    
    // Update timestamp
    dids[didIndex].updated = new Date().toISOString();
    
    // Save changes
    await fs.writeFile(DID_FILE, JSON.stringify(dids, null, 2));
    
    return dids[didIndex];
  } catch (error) {
    console.error(`Error updating DID ${didId}:`, error);
    throw error;
  }
};

// Delete a DID
const deleteDid = async (didId) => {
  try {
    const dids = await getAllDids();
    const filteredDids = dids.filter(did => did.id !== didId);
    
    if (filteredDids.length === dids.length) {
      throw new Error(`DID ${didId} not found`);
    }
    
    await fs.writeFile(DID_FILE, JSON.stringify(filteredDids, null, 2));
    
    return { id: didId, deleted: true };
  } catch (error) {
    console.error(`Error deleting DID ${didId}:`, error);
    throw error;
  }
};

module.exports = {
  initialize,
  getAllDids,
  getDidById,
  createDid,
  updateDidDocument,
  deleteDid
};
```

### 2. Cryptographic Key Generation

Implement key generation for DIDs:

```javascript
// src/utils/keyUtils.js
const crypto = require('crypto');
const { base58btc } = require('multiformats/bases/base58');
const { Ed25519Provider } = require('key-did-provider-ed25519');

// Generate Ed25519 key pair
const generateEd25519KeyPair = () => {
  // Generate key pair
  const keyPair = crypto.generateKeyPairSync('ed25519');
  
  // Get raw keys
  const publicKeyRaw = keyPair.publicKey.export({ type: 'spki', format: 'der' });
  const privateKeyRaw = keyPair.privateKey.export({ type: 'pkcs8', format: 'der' });
  
  // Extract actual key bytes
  const publicKeyBytes = publicKeyRaw.slice(-32);
  const privateKeyBytes = privateKeyRaw.slice(-32);
  
  // Convert to multibase format
  const publicKeyMultibase = 'z' + base58btc.encode(publicKeyBytes);
  const privateKeyMultibase = 'z' + base58btc.encode(privateKeyBytes);
  
  return {
    publicKeyMultibase,
    privateKeyMultibase
  };
};

// Create a DID provider from a seed
const createDidProvider = (seed) => {
  return new Ed25519Provider(seed);
};

module.exports = {
  generateEd25519KeyPair,
  createDidProvider
};
```

### 3. DID Controller

Create a controller to handle DID-related API requests:

```javascript
// src/controllers/didController.js
const didService = require('../services/didService');
const keyUtils = require('../utils/keyUtils');

// Get all DIDs
exports.getAllDids = async (req, res) => {
  try {
    const dids = await didService.getAllDids();
    
    // Remove private key data for security
    const sanitizedDids = dids.map(did => {
      const { privateKeyMultibase, ...sanitizedDid } = did;
      return sanitizedDid;
    });
    
    res.json(sanitizedDids);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get DID by ID
exports.getDidById = async (req, res) => {
  try {
    const { didId } = req.params;
    const did = await didService.getDidById(didId);
    
    if (!did) {
      return res.status(404).json({ error: 'DID not found' });
    }
    
    // Remove private key data for security
    const { privateKeyMultibase, ...sanitizedDid } = did;
    
    res.json(sanitizedDid);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get DID document (public endpoint)
exports.getDidDocument = async (req, res) => {
  try {
    const { didId } = req.params;
    const did = await didService.getDidById(didId);
    
    if (!did) {
      return res.status(404).json({ error: 'DID not found' });
    }
    
    res.json(did.document);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Create a new DID
exports.createDid = async (req, res) => {
  try {
    const { domain, path, controller } = req.body;
    
    if (!domain) {
      return res.status(400).json({ error: 'Domain is required' });
    }
    
    // Generate key pair
    const keyPair = keyUtils.generateEd25519KeyPair();
    
    // Create DID
    const didRecord = await didService.createDid(domain, path, controller, keyPair);
    
    // Remove private key from response
    const { privateKeyMultibase, ...sanitizedDid } = didRecord;
    
    res.status(201).json(sanitizedDid);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update a DID document
exports.updateDidDocument = async (req, res) => {
  try {
    const { didId } = req.params;
    const updates = req.body;
    
    // Validate updates
    if (!updates || Object.keys(updates).length === 0) {
      return res.status(400).json({ error: 'No updates provided' });
    }
    
    // Update DID document
    const updatedDid = await didService.updateDidDocument(didId, updates);
    
    // Remove private key from response
    const { privateKeyMultibase, ...sanitizedDid } = updatedDid;
    
    res.json(sanitizedDid);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Delete a DID
exports.deleteDid = async (req, res) => {
  try {
    const { didId } = req.params;
    
    const result = await didService.deleteDid(didId);
    
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
```

### 4. Authentication Middleware

Implement JWT authentication for API security:

```javascript
// src/middleware/auth.js
const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';

// Authenticate API requests
exports.authenticate = (req, res, next) => {
  try {
    // Get token from header
    const token = req.header('Authorization')?.replace('Bearer ', '');
    
    if (!token) {
      return res.status(401).json({ error: 'Authentication required' });
    }
    
    // Verify token
    const decoded = jwt.verify(token, JWT_SECRET);
    
    // Add user info to request
    req.user = decoded;
    
    next();
  } catch (error) {
    res.status(401).json({ error: 'Authentication failed' });
  }
};

// Generate a token for a user
exports.generateToken = (userId, role) => {
  const payload = {
    userId,
    role,
    iat: Math.floor(Date.now() / 1000)
  };
  
  return jwt.sign(payload, JWT_SECRET, { expiresIn: '1h' });
};
```

### 5. API Registry Integration

Implement a client to interact with the API Registry:

```javascript
// src/api-registry-client.js
const axios = require('axios');

// Default configuration
const config = {
  apiRegistryUrl: process.env.API_REGISTRY_URL || 'http://api-registry:3005',
  apiKey: process.env.API_REGISTRY_KEY
};

// Register API specification with the API Registry
const registerApiSpec = async (serviceName, version, specification) => {
  try {
    if (!config.apiKey) {
      throw new Error('API Registry key not configured');
    }
    
    const response = await axios.post(
      `${config.apiRegistryUrl}/specs`,
      {
        serviceName,
        version,
        specification,
        description: `${serviceName} API v${version}`
      },
      {
        headers: {
          'X-API-Key': config.apiKey,
          'Content-Type': 'application/json'
        }
      }
    );
    
    console.log(`API specification registered successfully: ${serviceName} v${version}`);
    return response.data;
  } catch (error) {
    console.error('Failed to register API specification:', error.response?.data || error.message);
    throw error;
  }
};

// Get API specification for a service
const getApiSpec = async (serviceName, version = 'latest') => {
  try {
    if (!config.apiKey) {
      throw new Error('API Registry key not configured');
    }
    
    const endpoint = version === 'latest'
      ? `${config.apiRegistryUrl}/specs/${serviceName}/latest`
      : `${config.apiRegistryUrl}/specs/${serviceName}/${version}`;
    
    const response = await axios.get(endpoint, {
      headers: {
        'X-API-Key': config.apiKey
      }
    });
    
    return response.data;
  } catch (error) {
    console.error(`Failed to get API specification for ${serviceName}:`, error.response?.data || error.message);
    throw error;
  }
};

// List all services in the API Registry
const listServices = async () => {
  try {
    if (!config.apiKey) {
      throw new Error('API Registry key not configured');
    }
    
    const response = await axios.get(`${config.apiRegistryUrl}/specs`, {
      headers: {
        'X-API-Key': config.apiKey
      }
    });
    
    return response.data;
  } catch (error) {
    console.error('Failed to list services:', error.response?.data || error.message);
    throw error;
  }
};

// Configure the client
const configure = (options) => {
  if (options.apiRegistryUrl) {
    config.apiRegistryUrl = options.apiRegistryUrl;
  }
  
  if (options.apiKey) {
    config.apiKey = options.apiKey;
  }
};

module.exports = {
  registerApiSpec,
  getApiSpec,
  listServices,
  configure
};
```

### 6. Routes

Set up the Express routes:

```javascript
// src/routes/index.js
const express = require('express');
const { authenticate } = require('../middleware/auth');
const didController = require('../controllers/didController');
const authController = require('../controllers/authController');

const router = express.Router();

// Public routes
router.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

router.post('/auth/login', authController.login);

// DID document endpoint (public)
router.get('/did/:didId', didController.getDidDocument);

// Protected routes
router.get('/dids', authenticate, didController.getAllDids);
router.post('/dids', authenticate, didController.createDid);
router.get('/dids/:didId', authenticate, didController.getDidById);
router.put('/dids/:didId', authenticate, didController.updateDidDocument);
router.delete('/dids/:didId', authenticate, didController.deleteDid);

module.exports = router;
```

### 7. Authentication Controller

Implement user authentication:

```javascript
// src/controllers/authController.js
const { generateToken } = require('../middleware/auth');

// Simple user database (replace with actual database in production)
const users = [
  {
    id: '1',
    username: 'admin',
    password: 'admin123',
    role: 'admin'
  },
  {
    id: '2',
    username: 'user',
    password: 'user123',
    role: 'user'
  }
];

// Login handler
exports.login = (req, res) => {
  try {
    const { username, password } = req.body;
    
    if (!username || !password) {
      return res.status(400).json({ error: 'Username and password are required' });
    }
    
    // Find user (in production, use a database)
    const user = users.find(u => u.username === username && u.password === password);
    
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }
    
    // Generate token
    const token = generateToken(user.id, user.role);
    
    res.json({
      message: 'Login successful',
      token,
      user: {
        id: user.id,
        username: user.username,
        role: user.role
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
```

### 8. Server Setup

Set up the Express server:

```javascript
// src/index.js
const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const routes = require('./routes');
const didService = require('./services/didService');
const apiRegistryClient = require('./api-registry-client');
const fs = require('fs');
const path = require('path');

// Read API specification
const apiSpec = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'specifications', 'api-spec.json'), 'utf8'));

const app = express();
const PORT = process.env.PORT || 3006;

// Configure API Registry client
apiRegistryClient.configure({
  apiRegistryUrl: process.env.API_REGISTRY_URL || 'http://api-registry:3005',
  apiKey: process.env.API_REGISTRY_KEY
});

// Middleware
app.use(cors());
app.use(express.json());
app.use(morgan('dev')); // Logging

// Routes
app.use('/', routes);

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

// Initialize services
const initializeServices = async () => {
  try {
    // Initialize DID service
    await didService.initialize();
    
    // Register with API Registry
    if (process.env.API_REGISTRY_KEY) {
      await apiRegistryClient.registerApiSpec('did-registry', '1.0.0', apiSpec);
    }
    
    console.log('All services initialized successfully');
  } catch (error) {
    console.error('Error initializing services:', error);
    process.exit(1);
  }
};

// Start server
app.listen(PORT, async () => {
  console.log(`DID Registry running on port ${PORT}`);
  
  // Initialize services
  await initializeServices();
});
```

## Sample DID Document

This is what a did:web document should look like:

```json
{
  "@context": [
    "https://www.w3.org/ns/did/v1",
    "https://w3id.org/security/suites/ed25519-2020/v1"
  ],
  "id": "did:web:example.com",
  "controller": "did:web:example.com",
  "verificationMethod": [
    {
      "id": "did:web:example.com#key-1",
      "type": "Ed25519VerificationKey2020",
      "controller": "did:web:example.com",
      "publicKeyMultibase": "z6MkhaXgBZDvotDkL5257faiztiGiC2QtKLGpbnnEGta2doK"
    }
  ],
  "authentication": [
    "did:web:example.com#key-1"
  ],
  "assertionMethod": [
    "did:web:example.com#key-1"
  ]
}
```

## Testing

1. Create a DID and verify the document structure
2. Test DID document retrieval
3. Test authentication and authorization
4. Verify API Registry integration
5. Test updating and deleting DIDs

## Additional Resources

- [DID Web Method Specification](https://w3c-ccg.github.io/did-method-web/)
- [W3C DID Core Specification](https://www.w3.org/TR/did-core/)
- [JSON Web Tokens](https://jwt.io/)

# Model Context Protocol Servers Guide

A comprehensive guide to all available MCP servers and their installation instructions.

## Available Servers

### Data Storage & Retrieval

#### 1. AWS Knowledge Base Retrieval Server
```bash
# Installation
cd src/aws-kb-retrieval-server
npm install
npm run build

# Environment Variables
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_REGION=your_region
```

#### 2. SQLite Server
```bash
# Installation
cd src/sqlite
pip install -e ".[dev]"

# Usage
python -m mcp_server_sqlite
```

#### 3. PostgreSQL Server
```bash
# Installation
cd src/postgres
npm install
npm run build

# Environment Variables
POSTGRES_CONNECTION_STRING=your_connection_string
```

### Search & Discovery

#### 4. Brave Search Server
```bash
# Installation
cd src/brave-search
npm install
npm run build

# Environment Variables
BRAVE_API_KEY=your_api_key
```

#### 5. Everything Search Server
```bash
# Installation
cd src/everything
npm install
npm run build

# Requirements
- Everything search engine installed
```

### Version Control Integration

#### 6. Git Server
```bash
# Installation
cd src/git
pip install -e ".[dev]"

# Usage
python -m mcp_server_git
```

#### 7. GitHub Server
```bash
# Installation
cd src/github
npm install
npm run build

# Environment Variables
GITHUB_TOKEN=your_token
```

#### 8. GitLab Server
```bash
# Installation
cd src/gitlab
npm install
npm run build

# Environment Variables
GITLAB_TOKEN=your_token
```

### Cloud Services

#### 9. Google Drive Server
```bash
# Installation
cd src/gdrive
npm install
npm run build

# Environment Variables
GOOGLE_CREDENTIALS=path_to_credentials.json
```

#### 10. Google Maps Server
```bash
# Installation
cd src/google-maps
npm install
npm run build

# Environment Variables
GOOGLE_MAPS_API_KEY=your_api_key
```

### Utility Servers

#### 11. Memory Server
```bash
# Installation
cd src/memory
npm install
npm run build
```

#### 12. Time Server
```bash
# Installation
cd src/time
pip install -e ".[dev]"

# Usage
python -m mcp_server_time
```

#### 13. Filesystem Server
```bash
# Installation
cd src/filesystem
npm install
npm run build
```

### Web & Browser Integration

#### 14. Fetch Server
```bash
# Installation
cd src/fetch
pip install -e ".[dev]"

# Usage
python -m mcp_server_fetch
```

#### 15. Puppeteer Server
```bash
# Installation
cd src/puppeteer
npm install
npm run build

# Requirements
- Chrome/Chromium installed
```

### Communication & Monitoring

#### 16. Slack Server
```bash
# Installation
cd src/slack
npm install
npm run build

# Environment Variables
SLACK_TOKEN=your_token
```

#### 17. Sentry Server
```bash
# Installation
cd src/sentry
pip install -e ".[dev]"

# Environment Variables
SENTRY_DSN=your_dsn
```

## Global Installation

### Using Docker

Each server includes a Dockerfile. To build and run:

```bash
# Build server
cd src/server-name
docker build -t mcp-server-name .

# Run server
docker run -p PORT:PORT \
  -e ENV_VAR=value \
  mcp-server-name
```

### Using Docker Compose

```yaml
version: '3.8'

services:
  sqlite:
    build: ./src/sqlite
    ports:
      - "5000:5000"

  github:
    build: ./src/github
    ports:
      - "5001:5001"
    environment:
      - GITHUB_TOKEN=your_token

  # Add other servers as needed
```

## Development Setup

### TypeScript Servers
```bash
# Install dependencies
npm install

# Build
npm run build

# Run in development
npm run dev

# Run tests
npm test
```

### Python Servers
```bash
# Install dependencies
pip install -e ".[dev]"

# Run server
python -m server_name

# Run tests
pytest
```

## Configuration Management

### Environment Variables
Create a `.env` file in each server directory:

```env
# Common variables
MCP_SERVER_PORT=5000
MCP_SERVER_HOST=0.0.0.0

# Server-specific variables
SERVER_API_KEY=your_key
```

### Server Configuration
```json
{
  "server": {
    "port": 5000,
    "host": "0.0.0.0",
    "timeout": 30000
  },
  "logging": {
    "level": "info",
    "format": "json"
  }
}
```

## Testing

### Unit Tests
```bash
# TypeScript servers
npm test

# Python servers
pytest
```

### Integration Tests
```bash
# Run all integration tests
npm run test:integration

# Test specific server
npm run test:integration -- --server=github
```

## Deployment

### Docker Deployment
```bash
# Build all servers
docker-compose build

# Run all servers
docker-compose up -d

# Monitor logs
docker-compose logs -f
```

### Kubernetes Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mcp-server
spec:
  replicas: 3
  template:
    spec:
      containers:
        - name: mcp-server
          image: mcp-server:latest
          ports:
            - containerPort: 5000
          env:
            - name: MCP_SERVER_PORT
              value: "5000"
```

## Monitoring & Logging

### Health Checks
All servers implement health check endpoints:
```bash
# Check server health
curl http://localhost:5000/health

# Check server metrics
curl http://localhost:5000/metrics
```

### Logging
```bash
# View server logs
docker logs mcp-server-name

# Stream logs
docker logs -f mcp-server-name

# Filter logs
docker logs mcp-server-name | grep ERROR
```

## Security

### Best Practices
1. Always use environment variables for sensitive data
2. Enable HTTPS in production
3. Implement rate limiting
4. Use proper authentication

### Authentication
```bash
# Set authentication token
export MCP_AUTH_TOKEN=your_token

# Use in requests
curl -H "Authorization: Bearer $MCP_AUTH_TOKEN" \
  http://localhost:5000/api/endpoint
```

## Troubleshooting

### Common Issues

1. **Port Conflicts**
```bash
# Check port usage
lsof -i :5000

# Change port
export MCP_SERVER_PORT=5001
```

2. **Authentication Errors**
```bash
# Verify environment variables
printenv | grep MCP

# Test authentication
curl -v -H "Authorization: Bearer $TOKEN" \
  http://localhost:5000/api/test
```

3. **Connection Issues**
```bash
# Check server status
docker ps

# Check logs
docker logs mcp-server-name

# Restart server
docker-compose restart server-name
```

## Performance Tuning

### Memory Management
```bash
# Set memory limits
docker run -m 512m mcp-server-name

# Monitor memory usage
docker stats mcp-server-name
```

### Connection Pooling
```javascript
// Example configuration
{
  "pool": {
    "max": 20,
    "min": 5,
    "idle": 10000
  }
}
```

### Caching
```javascript
// Enable caching
{
  "cache": {
    "enabled": true,
    "ttl": 3600,
    "max": 1000
  }
}
```
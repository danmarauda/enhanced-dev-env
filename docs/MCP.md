# Model Context Protocol (MCP) Guide

A comprehensive guide to using the Model Context Protocol servers and tools in the development environment.

## 🚀 Quick Start

```bash
# Start Python MCP server
mcp start python

# Start Rust MCP server
mcp start rust

# Run tests
mcp test

# Run benchmarks
mcp bench
```

## 📦 Available Implementations

### Python Implementation
```bash
# Start server
mcp-py

# Build from source
mcp build python
```

### Rust Implementation
```bash
# Start server
mcp-rs

# Build from source
mcp build rust
```

## 🛠️ Management Commands

### Basic Commands
```bash
# Start servers
mcp start python     # Start Python implementation
mcp start rust       # Start Rust implementation

# Testing
mcp test            # Run test suite
mcp bench           # Run benchmarks

# Building
mcp build python    # Build Python implementation
mcp build rust      # Build Rust implementation
```

### Protocol Tools
```bash
# Protocol validation
mcp-proto validate                  # Validate protocol spec
mcp-proto generate --lang python    # Generate Python code
mcp-proto check implementations/python  # Check implementation
```

## 🔌 Server Configuration

### Python Server
```bash
# Default configuration
mcp-py

# Custom port
mcp-py --port 5000

# Debug mode
mcp-py --debug
```

### Rust Server
```bash
# Default configuration
mcp-rs

# Custom port
mcp-rs --port 5001

# Release mode
mcp-rs --release
```

## 📚 Development Workflows

### Setting Up Development Environment
```bash
# 1. Build implementations
mcp build python
mcp build rust

# 2. Run tests
mcp test

# 3. Start server
mcp start python
```

### Testing Protocol Changes
```bash
# 1. Validate protocol
mcp-proto validate

# 2. Generate code
mcp-proto generate --lang python
mcp-proto generate --lang rust

# 3. Check implementation
mcp-proto check implementations/python
mcp-proto check implementations/rust
```

### Benchmarking
```bash
# Run all benchmarks
mcp bench

# Run specific benchmark
mcp bench --test inference
```

## 🔍 Implementation Details

### Directory Structure
```
/opt/mcp/
├── implementations/
│   ├── python/
│   └── rust/
├── protocol/
├── tests/
└── benchmarks/
```

### Source Code Locations
- Python: `/opt/mcp/implementations/python`
- Rust: `/opt/mcp/implementations/rust`
- Protocol: `/opt/mcp/protocol`

## 🔧 Protocol Development

### Validation
```bash
# Check protocol specification
mcp-proto validate

# Detailed validation
mcp-proto validate --verbose
```

### Code Generation
```bash
# Generate Python code
mcp-proto generate --lang python

# Generate Rust code
mcp-proto generate --lang rust
```

### Implementation Checking
```bash
# Check Python implementation
mcp-proto check implementations/python

# Check Rust implementation
mcp-proto check implementations/rust
```

## 📊 Performance Testing

### Running Benchmarks
```bash
# Full benchmark suite
mcp bench

# Specific components
mcp bench --component inference
mcp bench --component tokenization
```

### Profiling
```bash
# Python profiling
python -m cProfile -o profile.stats $(which mcp-py)
python -m pstats profile.stats

# Rust profiling
cargo profiler callgrind --bin mcp-server
```

## 🔍 Troubleshooting

### Common Issues

1. **Build Failures**
```bash
# Clean and rebuild Python
cd /opt/mcp/implementations/python
rm -rf build dist *.egg-info
mcp build python

# Clean and rebuild Rust
cd /opt/mcp/implementations/rust
cargo clean
mcp build rust
```

2. **Test Failures**
```bash
# Detailed test output
mcp test -v

# Specific test file
mcp test tests/test_inference.py
```

3. **Server Issues**
```bash
# Check logs
mcp start python --log-level debug

# Check port availability
lsof -i :5000
```

## 🔄 Updates and Maintenance

### Updating Source Code
```bash
# Update repository
cd /opt/mcp
git pull

# Rebuild implementations
mcp build python
mcp build rust
```

### Running Tests
```bash
# Full test suite
mcp test

# With coverage
mcp test --cov

# Generate report
mcp test --cov --cov-report=html
```

## 📚 Additional Resources

### Documentation
- [Protocol Specification](https://github.com/modelcontextprotocol/servers/blob/main/PROTOCOL.md)
- [Python Implementation](https://github.com/modelcontextprotocol/servers/tree/main/implementations/python)
- [Rust Implementation](https://github.com/modelcontextprotocol/servers/tree/main/implementations/rust)

### Contributing
```bash
# Create new branch
git checkout -b feature/new-feature

# Run tests
mcp test

# Check implementation
mcp-proto check implementations/python

# Submit PR
git push origin feature/new-feature
```
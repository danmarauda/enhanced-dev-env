# Development Environment Setup History
*December 26, 2024*

## Timeline of Development

### 1. Initial UV Package Manager Setup
- Exported `LIGHTNING_API_KEY` environment variable
- Exported `LIGHTNING_USER_ID` environment variable
- Added exports to `.zshrc` for persistence
- Verified environment variable setup

### 2. ZSH Configuration Optimization
- Cleaned up `.zshrc` file
- Removed duplicate entries
- Organized configuration sections
- Fixed initialization issues
- Added proper path management
- Structured environment variables

### 3. UV Configuration Enhancement
- Created optimized UV configuration
- Added cache management
- Set up performance optimizations
- Created utility functions
- Added development shortcuts
- Implemented project templates

### 4. Development Environment Creation
Created comprehensive development environment with:

#### Base Configuration Files
1. `Dockerfile` - Container definition
2. `docker-compose.yml` - Container orchestration
3. `Vagrantfile` - VM configuration
4. `.zshrc` - Shell configuration
5. `uvconfig.toml` - UV package manager configuration

#### Directory Structure
```
dev-environment/
├── Dockerfile
├── docker-compose.yml
├── Vagrantfile
├── .zshrc
├── workspace/
└── .config/
    └── uv/
```

### 5. Tool Integration
Added comprehensive development tools:

#### Base Tools
- Git
- Vim
- Tmux
- Docker
- Python 3.11

#### Modern CLI Tools
- exa (modern ls)
- bat (modern cat)
- ripgrep (modern grep)
- fd-find (modern find)
- delta (git diff)
- zoxide (smart cd)
- starship (shell prompt)
- dust (modern du)
- hyperfine (benchmarking)

#### Development Tools
- UV package manager
- IPython
- Black (formatter)
- isort (import sorter)
- mypy (type checker)
- ruff (linter)
- pytest (testing)
- debugpy (debugging)
- pre-commit

### 6. AI/ML Enhancement
Added AI and ML development capabilities:

#### AI/ML Tools
- Open Interpreter (dev branch)
- PyTorch
- Transformers
- Datasets
- LangChain
- ChromaDB
- Jupyter environment
- TensorBoard

#### Performance Tools
- memray
- viztracer
- line_profiler
- py-spy
- scalene

### 7. Project Templates
Implemented quick-start project templates:

#### FastAPI Template
```bash
new-fastapi myapi
```
- Complete FastAPI project structure
- Database configuration
- API routing setup
- Development server

#### ML Project Template
```bash
new-ml myproject
```
- Data directories
- Notebook setup
- Model management
- Pipeline structure

#### LLM Project Template
```bash
new-llm myproject
```
- Prompt templates
- Agent structure
- Model management
- Environment configuration

## Key Features Implemented

### 1. Package Management
- UV as default package manager
- Optimized caching
- Parallel installation
- Binary wheel preference

### 2. Development Workflow
- Project templates
- Testing setup
- Documentation structure
- Git configuration

### 3. Performance Tools
- Memory profiling
- CPU profiling
- Benchmark utilities
- Performance monitoring

### 4. AI/ML Development
- GPU support
- Jupyter integration
- Model development tools
- Data processing utilities

### 5. Environment Management
- Virtual environment handling
- Dependency management
- Project isolation
- Configuration management

## Comprehensive Usage Guide

### 1. Environment Setup

#### Docker Container Setup
```bash
# Initial setup
cd ~/dev-environment
docker-compose up -d
docker-compose exec dev zsh

# Rebuild container with updates
docker-compose build --no-cache
docker-compose up -d

# Check container status
docker-compose ps

# View container logs
docker-compose logs -f
```

#### VM Setup
```bash
# Initial setup
cd ~/dev-environment
vagrant up
vagrant ssh

# Update VM
vagrant provision

# Suspend/Resume VM
vagrant suspend
vagrant resume

# Destroy and recreate
vagrant destroy -f
vagrant up
```

### 2. Project Development Workflows

#### FastAPI Development Workflow
```bash
# Create new FastAPI project
new-fastapi myapi
cd myapi

# Set up development environment
venv-create
venv-activate
python-deps

# Start development server
uvicorn src.myapi.api.main:app --reload --port 8000

# Run tests
pytest
pytest --cov=src

# Profile endpoint performance
profile-viz "uvicorn src.myapi.api.main:app" &
curl http://localhost:8000/
profile-viz stop
```

#### Machine Learning Workflow
```bash
# Create new ML project
new-ml ml-project
cd ml-project

# Set up environment
venv-create
venv-activate

# Start Jupyter Lab with GPU monitoring
torch-gpu  # Verify GPU availability
lab

# Profile model training
profile-mem train.py
profile-mem-flamegraph train.py  # Generate memory usage visualization

# Benchmark different approaches
benchmark "python train.py --model-type a" "python train.py --model-type b"

# Monitor training process
profile-all train.py  # Full system monitoring
```

#### LLM Development Workflow
```bash
# Create new LLM project
new-llm llm-project
cd llm-project

# Set up environment
venv-create
venv-activate
cp .env.template .env
vim .env  # Add your API keys

# Interactive development with Open Interpreter
oi

# Test prompt templates
python -c "
from langchain import PromptTemplate
with open('prompts/templates/base.txt', 'r') as f:
    template = f.read()
prompt = PromptTemplate.from_template(template)
print(prompt.format(user_input='Tell me a joke'))
"

# Profile embedding generation
profile-mem src/embeddings/generate.py
```

### 3. Development Tools Usage

#### Package Management
```bash
# Install packages with UV
python-install pandas numpy torch

# Update all packages
uv-upgrade

# Check dependency tree
python-deps

# Rebuild virtual environment
uv-venv-rebuild

# Clean cache
uv-clean
```

#### Code Quality Tools
```bash
# Format code
black src/
isort src/

# Lint code
ruff src/
mypy src/

# Run all quality checks
pre-commit run --all-files
```

#### Performance Profiling
```bash
# Memory usage analysis
profile-mem script.py
profile-mem-flamegraph script.py > memory.html

# CPU profiling
profile-cpu script.py  # Creates SVG visualization
profile-line script.py  # Line-by-line profiling

# Visual trace
profile-viz script.py  # Creates interactive visualization

# Complete system analysis
profile-all script.py  # CPU, memory, and I/O analysis

# Quick benchmark
benchmark "python script.py" 10  # Run 10 iterations
```

#### Jupyter Environment
```bash
# Start Jupyter Notebook
nb

# Start Jupyter Lab with specific port
lab --port 8888 --ip 0.0.0.0

# Convert notebook to script
jupyter nbconvert --to script notebook.ipynb

# Start with resource monitoring
profile-viz "jupyter lab" &
```

### 4. Common Development Tasks

#### Git Integration
```bash
# Initialize with templates
git init
uv-project-check  # Verifies project structure

# Pre-commit setup
pre-commit install
pre-commit run --all-files

# View changes with modern tools
g diff  # Uses delta for better diff viewing
```

#### Docker Operations
```bash
# Build and run services
dc build
dc up -d
dc logs -f

# Execute commands in container
dc exec dev pytest
dc exec dev profile-mem script.py
```

#### System Maintenance
```bash
# Check system status
uv-doctor

# Clean up space
uv-clean
docker system prune -af

# Update tools
dc build --no-cache  # Rebuild container with updates
```

### 5. Harbor Registry Integration

#### Basic Harbor Commands
```bash
# Quick shortcuts
h       # harbor
hp      # harbor project
hr      # harbor repo
hi      # harbor image

# Project setup
harbor-setup                    # Configure Harbor credentials
harbor-init myproject          # Initialize new Harbor project

# Image operations
harbor-scan myimage:latest     # Scan image for vulnerabilities
harbor-clean myrepo 10         # Clean old images, keep 10 latest
harbor-sync src:tag dest:tag   # Sync images between registries
```

#### Project Management
```bash
# Create new project
harbor-init myapp

# List projects
hp list

# Get project details
hp get myapp

# Delete project
hp delete myapp
```

#### Repository Operations
```bash
# List repositories
hr list myapp

# Get repository details
hr get myapp/repo

# Clean up old images
harbor-clean myapp/repo 5  # Keep 5 latest tags

# Set up repository policies
harbor repo set-policy myapp/repo \
  --auto-scan=true \
  --vulnerability=high
```

#### Image Management
```bash
# List images
hi list myapp/repo

# Get image details
hi get myapp/repo:tag

# Scan image
harbor-scan myapp/repo:tag

# Copy images
harbor-sync myapp/repo:tag newapp/repo:tag

# Delete image
hi delete myapp/repo:tag
```

#### CI/CD Integration
```bash
# In your CI pipeline
harbor-init ${CI_PROJECT_NAME}
harbor-scan ${IMAGE_NAME}:${CI_COMMIT_SHA}

# Clean up old images periodically
harbor-clean ${CI_PROJECT_PATH} 10

# Promote images across environments
harbor-sync \
  myapp/repo:staging \
  myapp/repo:production
```

#### Harbor Configuration
```yaml
# .harbor.yml example
project: myapp
repositories:
  - name: backend
    public: false
    vulnerability_scanning: true
    image_scanning: true
    retention:
      days: 30
      count: 10
  - name: frontend
    public: true
    vulnerability_scanning: true
    webhooks:
      - url: https://notify.example.com
        events: [PUSH, SCAN]
```

#### Advanced Usage
```bash
# Batch operations
for repo in $(hr list myapp); do
  harbor-scan myapp/$repo:latest
done

# Vulnerability monitoring
harbor-scan myapp/repo:latest | jq '.vulnerabilities[] | select(.severity=="CRITICAL")'

# Custom retention policies
harbor-clean myapp/repo --retain-count 10 \
  --retain-pattern "v*" \
  --untagged

# Image synchronization
harbor-sync \
  registry1.example.com/myapp:latest \
  registry2.example.com/myapp:latest
```

### 6. AI/ML Tools Integration

#### Open Interpreter Usage
```bash
# Start interactive session
oi

# Run with specific model
oi --model gpt-4

# Run with local model
oi --local

# Debug mode
oi --debug
```

#### TensorBoard Integration
```bash
# Start TensorBoard
tensorboard --logdir runs/ --port 6006

# Monitor multiple runs
tensorboard --logdir run1:./runs/exp1,run2:./runs/exp2
```

#### Model Development
```bash
# Check GPU status
torch-gpu

# Profile model training
profile-mem train.py
profile-viz train.py

# Benchmark inference
benchmark "python inference.py" 100
```

## Future Considerations

### Potential Enhancements
1. Additional AI model integrations
2. More project templates
3. Enhanced performance tools
4. Additional development utilities

### Maintenance
1. Regular updates to base images
2. Security patches
3. Tool version management
4. Configuration optimization

## Documentation
- README.md - Main documentation
- UV_COMMANDS.md - UV utility reference
- DEVELOPMENT_HISTORY.md - This development history

## Contributors
- Initial setup and configuration
- Tool integration and testing
- Documentation and maintenance
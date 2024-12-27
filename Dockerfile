# Start with a minimal Python base image
FROM python:3.11-slim-bookworm as builder

# Build arguments
ARG USER_NAME=developer
ARG USER_UID=1000
ARG USER_GID=1000

# Install essential build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    vim \
    wget \
    zsh \
    sqlite3 \
    libsqlite3-dev \
    libpq-dev \
    libffi-dev \
    ripgrep \
    fd-find \
    htop \
    tmux \
    fzf \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd --gid $USER_GID $USER_NAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USER_NAME \
    && chsh -s /usr/bin/zsh $USER_NAME

# Install UV
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Rust for additional tools
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install useful Rust-based tools
RUN cargo install \
    exa \
    bat \
    delta \
    zoxide \
    starship \
    du-dust \
    tokei \
    hyperfine

# Switch to non-root user
USER $USER_NAME
WORKDIR /home/$USER_NAME

# Install Oh My Zsh and plugins
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    # Install Powerlevel10k theme
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && \
    # Install plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting && \
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions && \
    git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search && \
    git clone https://github.com/djui/alias-tips ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/alias-tips && \
    # Install additional tools
    apt-get update && apt-get install -y \
        autojump \
        thefuck \
        fd-find \
        bat \
        tree \
        && rm -rf /var/lib/apt/lists/*

# Install Zsh plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting \
    && git clone https://github.com/djui/alias-tips ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/alias-tips

# Copy UV configuration
COPY --chown=$USER_NAME:$USER_NAME .config/uv /home/$USER_NAME/.config/uv

# Set up ZSH configuration
COPY --chown=$USER_NAME:$USER_NAME .zshrc /home/$USER_NAME/.zshrc

# Create development directories
RUN mkdir -p \
    /home/$USER_NAME/.cache/uv \
    /home/$USER_NAME/.local/share/virtualenvs \
    /home/$USER_NAME/workspace

# Install Node.js for Open Interpreter and other tools
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g pnpm yarn

# Install Harbor
RUN curl -fsSL https://raw.githubusercontent.com/avinor/harbor/main/install.sh | bash

# Install NVIDIA Container Toolkit
RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID) && \
    curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | apt-key add - && \
    curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Install system dependencies and AI/ML tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1-mesa-glx \
    nvidia-container-toolkit \
    cuda-toolkit-12-* \
    python3-dev \
    build-essential \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.ai/install.sh | sh

# Install LM Studio Server
RUN mkdir -p /opt/lmstudio && \
    curl -L https://github.com/lmstudio-ai/model-studio/releases/latest/download/lmstudio-linux.tar.gz | \
    tar xz -C /opt/lmstudio

# Install Text Generation WebUI
RUN git clone https://github.com/oobabooga/text-generation-webui.git /opt/text-generation-webui && \
    cd /opt/text-generation-webui && \
    pip install -r requirements.txt

# Install Model Context Protocol Servers
RUN git clone https://github.com/modelcontextprotocol/servers.git /opt/mcp && \
    cd /opt/mcp && \
    # Install Node.js dependencies
    npm install && \
    # Install Python servers
    cd src/fetch && pip install -e ".[dev]" && cd .. && \
    cd git && pip install -e ".[dev]" && cd .. && \
    cd sentry && pip install -e ".[dev]" && cd .. && \
    cd sqlite && pip install -e ".[dev]" && cd .. && \
    cd time && pip install -e ".[dev]" && cd .. && \
    # Install TypeScript servers
    cd aws-kb-retrieval-server && npm install && npm run build && cd .. && \
    cd brave-search && npm install && npm run build && cd .. && \
    cd everart && npm install && npm run build && cd .. && \
    cd everything && npm install && npm run build && cd .. && \
    cd filesystem && npm install && npm run build && cd .. && \
    cd gdrive && npm install && npm run build && cd .. && \
    cd github && npm install && npm run build && cd .. && \
    cd gitlab && npm install && npm run build && cd .. && \
    cd google-maps && npm install && npm run build && cd .. && \
    cd memory && npm install && npm run build && cd .. && \
    cd postgres && npm install && npm run build && cd .. && \
    cd puppeteer && npm install && npm run build && cd .. && \
    cd sequentialthinking && npm install && npm run build && cd .. && \
    cd slack && npm install && npm run build

# Install base Python packages globally
RUN /root/.cargo/bin/uv pip install \
    ipython \
    black \
    isort \
    mypy \
    ruff \
    pre-commit \
    httpx \
    rich \
    pytest \
    pytest-cov \
    pytest-asyncio \
    pytest-xdist \
    debugpy \
    pip-tools \
    tox \
    jupyter \
    jupyterlab \
    notebook \
    pandas \
    numpy \
    matplotlib \
    seaborn \
    scikit-learn \
    torch \
    transformers \
    datasets \
    langchain \
    openai \
    anthropic \
    chromadb \
    duckdb \
    fastapi \
    uvicorn[standard] \
    watchfiles \
    python-dotenv \
    pytest-benchmark \
    memray \
    viztracer \
    line_profiler \
    py-spy \
    scalene \
    && git clone https://github.com/KillianLucas/open-interpreter.git \
    && cd open-interpreter \
    && git checkout dev \
    && /root/.cargo/bin/uv pip install -e .

# Set environment variables
ENV UV_SYSTEM_PYTHON=1 \
    UV_VIRTUALENV_AUTO_CREATE=1 \
    UV_NO_MODIFY_PATH=1 \
    UV_CACHE_DIR=/home/$USER_NAME/.cache/uv \
    UV_CONFIG_DIR=/home/$USER_NAME/.config/uv \
    UV_VIRTUALENV_DIR=/home/$USER_NAME/.local/share/virtualenvs \
    VIRTUAL_ENV_DISABLE_PROMPT=1 \
    UV_PARALLEL_JOBS=4 \
    UV_BUILD_JOBS=4 \
    UV_NO_CACHE=0 \
    UV_HTTP_TIMEOUT=30 \
    UV_PREFER_BINARY=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    EDITOR=vim

# Set working directory
WORKDIR /home/$USER_NAME/workspace

# Default command
CMD ["zsh"]
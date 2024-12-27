# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "dev-box"

  # Network configuration
  config.vm.network "forwarded_port", guest: 8000, host: 8000  # FastAPI/Django
  config.vm.network "forwarded_port", guest: 3000, host: 3000  # Node.js
  config.vm.network "forwarded_port", guest: 5678, host: 5678  # Debug port

  # Sync folder configuration
  config.vm.synced_folder "workspace/", "/home/vagrant/workspace"

  # Provider-specific configuration
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = 2
    vb.name = "python-dev-environment"
  end

  # Provisioning script
  config.vm.provision "shell", inline: <<-SHELL
    # Update system
    apt-get update
    apt-get upgrade -y

    # Install essential packages
    apt-get install -y \
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
      jq

    # Install Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env

    # Install Rust tools
    cargo install \
      exa \
      bat \
      delta \
      zoxide \
      starship \
      du-dust \
      tokei \
      hyperfine

    # Install UV
    curl -LsSf https://astral.sh/uv/install.sh | sh

    # Set up Python environment
    mkdir -p /home/vagrant/.config/uv
    mkdir -p /home/vagrant/.cache/uv
    mkdir -p /home/vagrant/.local/share/virtualenvs

    # Install Oh My Zsh
    su - vagrant -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'

    # Install Zsh plugins
    su - vagrant -c 'git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'
    su - vagrant -c 'git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'
    su - vagrant -c 'git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting'
    su - vagrant -c 'git clone https://github.com/djui/alias-tips ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/alias-tips'

    # Change default shell to zsh
    chsh -s $(which zsh) vagrant
  SHELL

  # Copy configuration files
  config.vm.provision "file", source: ".zshrc", destination: "/home/vagrant/.zshrc"
  config.vm.provision "file", source: ".config/uv", destination: "/home/vagrant/.config/uv"
end
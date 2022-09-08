FROM fedora:34

# Initial setup
RUN dnf install -y \
    ncurses passwd \
    nano wget curl iproute \
    neovim tmux zsh git python3 python3-pip nodejs npm golang

# Install WSL utility
RUN npm install -g wsl-open && \
    ln -s /usr/local/bin/wsl-open /usr/local/bin/open
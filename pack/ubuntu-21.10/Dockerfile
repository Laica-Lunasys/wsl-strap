FROM ubuntu:21.10

ENV DEBIAN_FRONTEND nointeractive

# Initial setup
RUN apt-get update && \
    apt-get install -y \
    sudo nano wget curl iproute2 locales systemd \
    neovim tmux zsh git python3 python3-pip nodejs npm

# Install WSL utility
RUN npm install -g yarn wsl-open && \
    ln -s /usr/local/bin/wsl-open /usr/local/bin/open

# Install distrod
RUN curl -L -O "https://raw.githubusercontent.com/nullpo-head/wsl-distrod/main/install.sh" && \
    chmod +x install.sh && \
    ./install.sh install

# Update locale
RUN sed -i -E 's/# (en_US.UTF-8)/\1/' /etc/locale.gen && \
    sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen && \
    locale-gen
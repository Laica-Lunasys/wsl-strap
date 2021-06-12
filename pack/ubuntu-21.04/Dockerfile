FROM ubuntu:21.04

RUN echo -n "" > /etc/motd

# Initial setup
RUN apt-get update && \
    apt-get install -yqq \
    sudo nano wget curl iproute2 locales \
    neovim tmux zsh git python3 python3-pip nodejs npm golang

# Install WSL utility
RUN npm install -g yarn wsl-open && \
    ln -s /usr/local/bin/wsl-open /usr/local/bin/open

# Update locale
RUN sed -i -E 's/# (en_US.UTF-8)/\1/' /etc/locale.gen && \
    sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen && \
    locale-gen
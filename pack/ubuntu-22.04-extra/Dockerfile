FROM ubuntu:22.04

ENV DEBIAN_FRONTEND nointeractive

# Initial setup
RUN apt-get update && \
    apt-get install -y \
    sudo nano wget curl iproute2 locales systemd \
    neovim tmux zsh git python3 python3-pip nodejs npm zip htop golang

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

WORKDIR /tmp
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    sudo ./aws/install

RUN CURRENT_VERSION=$(curl -Ls https://api.github.com/repos/Versent/saml2aws/releases/latest | grep 'tag_name' | cut -d'v' -f2 | cut -d'"' -f1) && \
    wget -c https://github.com/Versent/saml2aws/releases/download/v${CURRENT_VERSION}/saml2aws_${CURRENT_VERSION}_linux_amd64.tar.gz -O - | tar -xzv -C /usr/local/bin && \
    chmod u+x /usr/local/bin/saml2aws
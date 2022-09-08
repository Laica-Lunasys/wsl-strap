FROM gentoo/stage3

# Initial setup
RUN emerge --sync && \
    emerge -g \
    sudo nano wget curl iproute2 \
    neovim tmux zsh git net-libs/nodejs sys-apps/yarn

# Install WSL utility
RUN yarn global add wsl-open && \
    ln -s /usr/local/bin/wsl-open /usr/local/bin/open

# Update locale
RUN echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen
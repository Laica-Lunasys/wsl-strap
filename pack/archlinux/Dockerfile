FROM docker.io/archlinux:base
WORKDIR /tmp

# Pacman settings
RUN sed -ie 's|#Color|Color|g' /etc/pacman.conf

# Initial setup
RUN pacman -Syyu --noconfirm && \
    pacman -S --noconfirm --needed base-devel sudo nano wget curl \
    neovim tmux zsh git nodejs yarn openssh htop

# Install X.org
RUN pacman -S --noconfirm --needed \
    xorg-server \
    xorg-apps \
    xorg-xinit \
    xterm && \
    ln -sf /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/70-no-bitmaps.conf

# Install WSL utility
RUN yarn global add wsl-open && \
    ln -s /usr/local/bin/wsl-open /usr/local/bin/open

# Enable systemd (official support)
RUN echo -e '[boot]\nsystemd=true' > /etc/wsl.conf

# Update locale
RUN sed -i -E 's/# (en_US.UTF-8)/\1/' /etc/locale.gen && \
    sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen && \
    locale-gen
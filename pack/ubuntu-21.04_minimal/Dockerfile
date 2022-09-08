FROM ubuntu:21.04

ENV DEBIAN_FRONTEND nointeractive

# Initial setup
RUN apt-get update && \
    apt-get install -yqq \
    sudo nano wget curl iproute2 locales

# Update locale
RUN sed -i -E 's/# (en_US.UTF-8)/\1/' /etc/locale.gen && \
    sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen && \
    locale-gen
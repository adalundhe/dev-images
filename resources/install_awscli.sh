#! /usr/bin/env bash

set -e

apt upgrade && \
    apt install -y coreutils

ARCH=$(arch)

if [[ "$ARCH" == "arm64" || "ARCH" == "aarch64" ]]; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" && \
    unzip -qq -o awscliv2.zip && \
    ./aws/install
else
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip -qq -o awscliv2.zip && \
    sudo ./aws/install
fi

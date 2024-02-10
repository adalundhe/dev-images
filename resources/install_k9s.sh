#!/bin/bash -i

set -e

if [[ ! -e /usr/local/go/bin ]]; then
    wget https://golang.org/dl/go1.22.0.linux-amd64.tar.gz \
    && sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz
fi

git clone https://github.com/derailed/k9s.git \
    && cd k9s \
    && make build \
    && mv ./execs/k9s /usr/local/bin

if [[ ! -e go1.22.0.linux-amd64.tar.gz ]]; then
    rm -rf go1.22.0.linux-amd64.tar.gz
    rm -rf /usr/local/go
fi
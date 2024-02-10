#!/bin/bash -i

set -e

USERNAME=${4:-"automatic"}

if [[ ! -e /usr/local/go/bin ]]; then
    wget https://golang.org/dl/go1.22.0.linux-amd64.tar.gz \
    && sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz
fi

# Determine the appropriate non-root user
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in ${POSSIBLE_USERS[@]}; do
        if id -u ${CURRENT_USER} > /dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u ${USERNAME} > /dev/null 2>&1; then
    USERNAME=root
fi

git clone https://github.com/derailed/k9s.git \
    && cd k9s \
    && make build \
    && mv ./execs/k9s /usr/local/bin \
    && cd .. \
    && rm -rf k9s

# If the tar exists we should remove it and the extra installed go.
if [[ -e go1.22.0.linux-amd64.tar.gz ]]; then
    rm -rf go1.22.0.linux-amd64.tar.gz
    rm -rf /usr/local/go
fi

rm -rf /root/go
rm -rf /home/${USERNAME}/go

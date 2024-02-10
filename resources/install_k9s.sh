#!/bin/bash -i

set -e

USERNAME=${4:-"automatic"}
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

architecture="$(uname -m)"
case $architecture in
    x86_64) architecture="amd64";;
    aarch64 | armv8*) architecture="arm64";;
    aarch32 | armv7* | armvhf*) architecture="arm";;
    i?86) architecture="386";;
    *) echo "(!) Architecture $architecture unsupported"; exit 1 ;;
esac

if [[ "$architecture" == "aarch64" ]]; then
    architecture="arm64"
fi

if [[ ! -e /usr/local/go/bin ]]; then

    wget "https://golang.org/dl/go1.22.0.linux-$architecture.tar.gz" \
    && sudo tar -C /usr/local -xzf "go1.22.0.linux-$architecture.tar.gz"

    git clone https://github.com/derailed/k9s.git \
    && cd k9s \
    && make build \
    && mv ./execs/k9s /usr/local/bin \
    && cd .. \
    && rm -rf k9s

    rm -rf go1.22.0.linux-amd64.tar.gz
    rm -rf /usr/local/go
else
    wget "https://github.com/derailed/k9s/releases/download/v0.31.8/k9s_linux_$architecture.deb"
    dpkg -i "k9s_linux_$architecture.deb" \
    rm -rf "k9s_linux_$architecture.deb"
fi


rm -rf /root/go
rm -rf /home/${USERNAME}/go

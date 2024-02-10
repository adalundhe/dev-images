#!/bin/bash -i

set -e

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

wget "https://github.com/derailed/k9s/releases/download/v0.31.8/k9s_linux_$architecture.deb"
dpkg -i "k9s_linux_$architecture.deb"
rm -rf "k9s_linux_$architecture.deb"

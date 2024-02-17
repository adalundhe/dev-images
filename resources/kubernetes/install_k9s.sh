#!/usr/bin/env bash

set -e

architecture="$(uname -m)"
case $architecture in
    x86_64) architecture="amd64";;
    aarch64 | arm64 | armv8*) architecture="arm64";;
    aarch32 | armv7* | armvhf*) architecture="arm";;
    i?86) architecture="386";;
    *) echo "(!) Architecture $architecture unsupported"; exit 1 ;;
esac

curl -s https://api.github.com/repos/derailed/k9s/releases/latest \
| grep "k9s_linux_$architecture.deb" \
| cut -d : -f 3 \
| tr -d \" \
| tr -d '\n' \
| wget "https:$(cat -)"


dpkg -i "k9s_linux_$architecture.deb"
rm -rf "k9s_linux_$architecture.deb"


#!/usr/bin/env bash

wget https://github.com/bazelbuild/bazelisk/releases/download/v1.8.1/bazelisk-linux-amd64

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

curl -s https://api.github.com/repos/bazelbuild/bazelisk/releases/latest \
| grep "bazelisk-linux-$architecture" \
| cut -d : -f 3 \
| tr -d \" \
| tr -d '\n' \
| wget "https:$(cat -)"

chmod +x bazelisk-linux-amd64
mv bazelisk-linux-amd64 /usr/local/bin/bazel
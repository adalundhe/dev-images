ARG BASE

FROM debian:${BASE}-slim
ARG VERSION
ARG JAVA_VARIANT=open
ARG USERNAME=vscode
ARG USER_UID=5000
ARG USER_GID=$USER_UID

RUN apt update && apt install -y \
    sudo \
    curl \
    git \
    gpg \
    unzip \
    zip \
    maven

RUN curl -s "https://get.sdkman.io" | bash

SHELL ["/bin/bash", "-c"] 
RUN source "/root/.sdkman/bin/sdkman-init.sh" && \
    sdk install java ${VERSION}-${JAVA_VARIANT} \
    && sdk install gradle

RUN curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ./ && \
    cp just /usr/local/bin/just && \
    rm -rf just

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt update && apt install -y gh

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" && \
    unzip -qq -o awscliv2.zip && \
    ./aws/install \
    && rm -rf awscliv2.zip \
    && rm -rf ./aws

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

COPY resources/shared/common_debian.sh /tmp/library-scripts/common_debian.sh

RUN apt clean \
    && apt update \
    && bash /tmp/library-scripts/common_debian.sh "true" "${USERNAME}" "${USER_UID}" "${USER_GID}" "true" "true" "true" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

COPY ./resources/java/.envrc /.envrc
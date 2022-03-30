FROM php:7.4-apache

RUN apt-get update -y
RUN apt-get install -y curl git wget nano rsync sshpass software-properties-common

RUN apt-get install -y docker.io apt-transport-https ca-certificates gnupg-agent
RUN curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --dry-run
RUN curl -fsSL https://code-server.dev/install.sh | sh

ENV VSCODEPASSW ""
ENV CSCONFIG "/root/.config/code-server"

RUN if [ "$VSCODEPASSW" == "" ] && [[ ! -f "$CSCONFIG/config.yaml" ] || [ $(cat "$CSCONFIG/config.yaml" | xargs) == "" ]]; then \
    echo "Creating configuration with NO password..." && mkdir -p "$CSCONFIG" && \
    echo "bind-addr: 0.0.0.0:6501" > "$CSCONFIG/config.yaml" && \
    echo "auth: none" >> "$CSCONFIG/config.yaml" && echo "cert: false" >> "$CSCONFIG/config.yaml"; fi

RUN if [ "$VSCODEPASSW" != "" ] && [[ ! -f "$CSCONFIG/config.yaml" ] || [ $(cat "$CSCONFIG/config.yaml" | xargs) == "" ]]; then \
    echo "Creating configuration with password..." && mkdir -p "$CSCONFIG" && \
    echo "bind-addr: 0.0.0.0:6501" > "$CSCONFIG/config.yaml" && \
    echo "auth: password" >> "$CSCONFIG/config.yaml" && \
    echo "password: $VSCODEPASSW" >> "$CSCONFIG/config.yaml" && echo "cert: false" >> "$CSCONFIG/config.yaml"; fi

CMD code-server


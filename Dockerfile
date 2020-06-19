FROM node:12.18-buster

# Installs git, unoconv and chinese fonts
RUN apt-get update && apt upgrade -y &&  apt-get -y install \
      git \
      unoconv=0.7-1.1 \
      ttf-wqy-zenhei \
      fonts-arphic-ukai \
      fonts-arphic-uming \
      fonts-indic \
    && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/zrrrzzt/tfk-api-unoconv.git unoconvservice

# Change working directory
WORKDIR /unoconvservice

# Install dependencies
RUN set -eux \
    && npm install --production
RUN set -eux \
    && apt -y install procps \
    && chown node:node /unoconvservice -R

# Env variables
ENV SERVER_PORT 5000
ENV PAYLOAD_MAX_SIZE 1048576
ENV TIMEOUT_SERVER 120000
ENV TIMEOUT_SOCKET 140000

USER node

# Expose 3000
EXPOSE 5000

# Startup
ENTRYPOINT /usr/bin/unoconv --listener --server=0.0.0.0 --port=2002 & node standalone.js

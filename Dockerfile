FROM node:10-buster-slim

# Install LibreOffice, git and fonts
# Credits:
# https://github.com/thecodingmachine/gotenberg
# https://github.com/arachnys/athenapdf/blob/master/cli/Dockerfile
# https://help.accusoft.com/PrizmDoc/v12.1/HTML/Installing_Asian_Fonts_on_Ubuntu_and_Debian.html
RUN mkdir -p /usr/share/man/man1mkdir -p /usr/share/man/man1 &&\
    echo "deb http://httpredir.debian.org/debian/ buster-backports main contrib non-free" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get -t buster-backports -y install libreoffice && \
    apt-get -y install \
    curl \
    git \
    culmus \
    ttf-wqy-zenhei \
    fonts-arphic-ukai \
    fonts-arphic-uming \
    fonts-indic \
&& rm -rf /var/lib/apt/lists/*

#### Begin setup ####

# Change working directory
WORKDIR /unoconvservice

# Install dependencies
COPY package.json .
RUN set -eux \
    && npm install --production
RUN set -eux \
    && adduser --uid 1003 coog --disabled-login \
    && adduser coog node \
    && adduser node coog \
    && chown coog:coog /unoconvservice -R \
    && chmod -R 771 /unoconvservice -R

# Install unoconv
# Credits:
# https://github.com/thecodingmachine/gotenberg
ENV UNO_URL=https://raw.githubusercontent.com/dagwieers/unoconv/master/unoconv
RUN curl -Ls $UNO_URL -o /usr/bin/unoconv &&\
    chmod +x /usr/bin/unoconv &&\
    ln -s /usr/bin/python3 /usr/bin/python &&\
    unoconv --version

# A helper for reaping zombie processes.
ENV TINI_VERSION=v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT [ "/tini", "--" ]


# Env variables
ENV SERVER_PORT 5000
ENV PAYLOAD_MAX_SIZE 1048576
ENV PAYLOAD_TIMEOUT 120000
ENV TIMEOUT_SERVER 120000
ENV TIMEOUT_SOCKET 140000

USER coog
COPY . /unoconvservice
# Expose 3000
EXPOSE 5000

# Startup
CMD ["node", "standalone.js"]

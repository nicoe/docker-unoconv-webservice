FROM node:10-buster-slim

# Install LibreOffice, git and fonts
# Credits:
# https://github.com/thecodingmachine/gotenberg
# https://github.com/arachnys/athenapdf/blob/master/cli/Dockerfile
# https://help.accusoft.com/PrizmDoc/v12.1/HTML/Installing_Asian_Fonts_on_Ubuntu_and_Debian.html
RUN mkdir -p /usr/share/man/man1mkdir -p /usr/share/man/man1 &&\
    echo "deb http://httpredir.debian.org/debian/ buster-backports main contrib non-free" >> /etc/apt/sources.list &&\
    apt-get update &&\
    apt-get -t buster-backports -y install libreoffice &&\
    apt-get -y install \
    git \
    culmus \
    fonts-beng \
    fonts-hosny-amiri \
    fonts-lklug-sinhala \
    fonts-lohit-guru \
    fonts-lohit-knda \
    fonts-samyak-gujr \
    fonts-samyak-mlym \
    fonts-samyak-taml \
    fonts-sarai \
    fonts-sil-abyssinica \
    fonts-sil-padauk \
    fonts-telu \
    fonts-thai-tlwg \
    fonts-liberation \
    ttf-wqy-zenhei \
    fonts-arphic-uming \
    fonts-ipafont-mincho \
    fonts-ipafont-gothic \
    fonts-unfonts-core \
&& rm -rf /var/lib/apt/lists/*

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

#### Begin setup ####

# Change working directory
WORKDIR /src

# Install dependencies
COPY package.json .
RUN npm install --production

# Env variables
ENV SERVER_PORT 3000
ENV PAYLOAD_MAX_SIZE 1048576
ENV PAYLOAD_TIMEOUT 120000
ENV TIMEOUT_SERVER 120000
ENV TIMEOUT_SOCKET 140000

# Bundle app source
COPY . /src

# Expose 3000
EXPOSE 3000

# Startup
CMD ["node", "standalone.js"]
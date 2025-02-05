# Copyright 2024 dah4k
# SPDX-License-Identifier: EPL-2.0

FROM ubuntu:24.04

ARG TZ=Etc/UTC
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install --assume-yes --no-upgrade --no-install-recommends \
        ## https://github.com/eclipse-theia/theia/blob/master/doc/Developing.md#prerequisites \
        make gcc pkg-config build-essential \
        libx11-dev libxkbfile-dev \
        libsecret-1-dev \
        nodejs npm \
        node-typescript \
        ## FIXME: yarn is still required for vscode.git-base plugin \
        yarn \
        ## HACK: npm ERR! ModuleNotFoundError: No module named 'distutils' \
        ## https://github.com/nodejs/node-gyp/pull/2888 \
        ## https://peps.python.org/pep-0632/ \
        python3-setuptools \
        ## DEV and DEBUG tools \
        curl \
        fd-find \
        file \
        git \
        plocate \
        ripgrep \
        vim \
        w3m \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

## No longer needed on Ubuntu 24.04 base image
#RUN groupadd --gid 1000 ubuntu && \
    #useradd --create-home --home-dir /src --uid 1000 --gid 1000 ubuntu

USER ubuntu

WORKDIR /src

RUN git clone https://github.com/eclipse-theia/theia-ide

WORKDIR /src/theia-ide

RUN npm install

RUN npm install node-gyp

#FIXME: Upgrading vulnerable dependencies breaks node-gyp...
#RUN npm audit fix --force

#--- collecting extension dependencies ---
#--- resolving 3 extension dependencies ---
#- redhat.java: already downloaded - skipping
#- vscjava.vscode-java-debug: already downloaded - skipping
#- vscode.git-base: already downloaded - skipping
#Parsing scenario file permissions:writeable
#ERROR: [Errno 2] No such file or directory: 'permissions:writeable'
#RUN npm run download:plugins

#RUN npm run build
#RUN npm run start:browser

#EXPOSE 3000
#ENTRYPOINT [ "npm" ]
#CMD [ "run", "start:browser" ]

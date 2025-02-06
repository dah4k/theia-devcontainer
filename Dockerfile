# Copyright 2024 dah4k
# SPDX-License-Identifier: EPL-2.0

FROM opensuse/tumbleweed:latest

## https://github.com/eclipse-theia/theia/blob/master/doc/Developing.md
RUN zypper --quiet --non-interactive refresh \
    && zypper --quiet --non-interactive install \
        gcc \
        gcc-c++ \
        libX11-devel \
        libsecret-devel \
        libxkbfile-devel \
        make \
        nodejs-default \
        nodejs22 \
        npm-default \
        npm22 \
        pkgconf-pkg-config \
        python311 \
        typescript \
        yarn \
        ## DEV and DEBUG tools \
        curl \
        fd \
        file \
        git \
        plocate \
        ripgrep \
        vim \
        w3m \
    && zypper --quiet --non-interactive clean

#RUN groupadd --gid 1000 opensuse \
#    && useradd --create-home --home-dir /src --uid 1000 --gid 1000 opensuse

#USER opensuse

WORKDIR /src

RUN git clone https://github.com/eclipse-theia/theia-ide

WORKDIR /src/theia-ide

RUN yarn
RUN yarn build
RUN yarn download:plugins
EXPOSE 3000
ENTRYPOINT [ "yarn" ]
CMD [ "browser", "start" ]

#RUN npm install
#RUN npm run build:dev
#RUN npm run download:plugins
#EXPOSE 3000
#ENTRYPOINT [ "npm" ]
#CMD [ "run", "start:browser" ]


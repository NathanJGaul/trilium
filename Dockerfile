FROM resin/rpi-raspbian:latest
ENTRYPOINT []

WORKDIR /tmp

# Install app dependencies
RUN apt-get update && \
    apt-get -qy install \
        autoconf \
        automake \
        g++ \
        gcc \
        libtool \
        make \
        nasm \
        libpng-dev \
        build-essential \
        wget \
        python \
        python-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists

ENV NODE_VERSION 10.15.0

RUN wget -O- --quiet https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.gz | tar xz \
    && cd node-v$NODE_VERSION \
	&& ./configure --without-snapshot \
	&& make -j $(nproc) \
	&& make install \
	&& cd /tmp \
	&& rm -rf /tmp/node-v$NODE_VERSION \
	&& npm install -g npm \
	&& npm cache clean
    
# Create app directory
WORKDIR /usr/src/app

# Copy both package.json and package-lock.json
# where available (npm@5+)
COPY package.json package-lock.json ./

RUN npm install --production

# Bundle app source
COPY . .

EXPOSE 8080
CMD [ "node", "./src/www" ]

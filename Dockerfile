FROM resin/rpi-raspbian:latest
ENTRYPOINT []

# Create app directory
WORKDIR /usr/src/app

# Copy both package.json and package-lock.json
# where available (npm@5+)
COPY package.json package-lock.json ./

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
    && npm install --production \

# Bundle app source
COPY . .

EXPOSE 8080
CMD [ "node", "./src/www" ]

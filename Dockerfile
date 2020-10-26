# FROM mhart/alpine-node:latest
FROM node:10-alpine
RUN mkdir -p /home/node/app && chown -R node:node /home/node/app
# RUN mkdir /data/mongodb/db:/data/db
# Create app directory
WORKDIR /home/node/app
# WORKDIR /usr/src/app

# Bundle app source
# COPY . .
# COPY package.json .
# For npm@5 or later, copy package-lock.json as well
COPY package*.json /home/node/app/

# Install app dependencies
RUN apk --no-cache --update add build-base && \
    apk --no-cache add libffi-dev openssl-dev && \
    apk --no-cache add g++ gcc libgcc libstdc++ linux-headers make python

RUN npm install
RUN npm install --quiet node-gyp -g
RUN npm install bcrypt --save

COPY --chown=node:node . .
# Bundle app source
# COPY . /home/node/app

RUN apk add --no-cache shadow make \
    && usermod -u 1001 node \
    && groupmod -g 1001 node

EXPOSE 3000

USER node

# Start Node server
# RUN npm install pm2 -g
# CMD [ "pm2-runtime", "npm", "--", "start" ]
CMD [ "npm", "start" ]

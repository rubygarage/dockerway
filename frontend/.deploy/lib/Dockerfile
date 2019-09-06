# Stage: Builder
FROM node:alpine as builder

ARG API_HOST
ARG NODE_ENV
ENV API_HOST=${API_HOST} NODE_ENV=${NODE_ENV}

ENV APP_HOME /home/www/frontend
WORKDIR $APP_HOME

COPY package.json yarn.lock ./
RUN yarn install --production

COPY . .

RUN yarn build

# Stage: Final
FROM node:alpine

ARG NODE_ENV
ENV NODE_ENV=${NODE_ENV}

RUN apk add --update --no-cache curl

ENV APP_HOME /home/www/frontend
WORKDIR $APP_HOME

USER node
COPY --from=builder --chown=node:node $APP_HOME ./

CMD ["yarn", "start", "-p", "4000"]

FROM ruby:2.6.3-alpine3.9

ARG BUNDLER_VERSION

RUN apk add --update --no-cache \
    build-base \
    libxml2-dev \
    libxslt-dev \
    postgresql-dev \
    tzdata \
    bash \
    curl \
    git \
    nodejs \
    yarn

ENV LANG=C.UTF-8 GEM_HOME=/bundle BUNDLE_JOBS=4 BUNDLE_RETRY=3
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH /app/bin:$BUNDLE_BIN:$PATH

RUN gem update --system && \
    gem install bundler:$BUNDLER_VERSION
RUN bundle config build.nokogiri --use-system-libraries

ENV APP_HOME /home/www/backend
WORKDIR $APP_HOME

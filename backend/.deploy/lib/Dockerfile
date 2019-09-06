# Stage: Builder
FROM ruby:2.6.3-alpine3.9 as Builder

ARG BUNDLE_WITHOUT
ARG RAILS_ENV

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

ENV APP_HOME /home/www/backend
ENV BUNDLE_WITHOUT=${BUNDLE_WITHOUT}

WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/
RUN bundle install --jobs 20 --retry 5 \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . $APP_HOME

RUN RAILS_ENV=${RAILS_ENV} bin/rake assets:precompile

# Stage: Final
FROM ruby:2.6.3-alpine3.9

RUN apk add --update --no-cache \
    libxml2-dev \
    libxslt-dev \
    postgresql-dev \
    file \
    tzdata \
    curl

ENV APP_USER app
ENV APP_HOME /home/www/backend

RUN addgroup -g 1000 -S $APP_USER  && adduser -u 1000 -S $APP_USER  -G $APP_USER

USER $APP_USER

COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder --chown=app:app $APP_HOME $APP_HOME

WORKDIR $APP_HOME

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

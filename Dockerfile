FROM ruby:2.7.7 AS oop-core

LABEL maintainer="jack.regnart@bluefrontier.co.uk"

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  apt-transport-https build-essential

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -

RUN apt-get install -y nodejs

WORKDIR /app/oop-renderer

COPY --from=openinterop/oop-renderer:version-1.0.7 /app /app/oop-renderer

RUN npm install -g yarn --force

RUN yarn

COPY Gemfile* /app/

WORKDIR /app

ENV BUNDLE_PATH /gems

RUN bundle install --without development test

COPY . /app/

ENTRYPOINT ./docker-entrypoint.sh


FROM ruby:2.6

LABEL maintainer="jack.regnart@bluefrontier.co.uk"

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  apt-transport-https

COPY Gemfile* /app/

WORKDIR /app

ENV BUNDLE_PATH /gems

RUN bundle install --without development test

COPY . /app/

CMD ["bin/rails", "s", "-b", "0.0.0.0"]

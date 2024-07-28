FROM ruby:2.7.0-alpine

ENV BUNDLER_VERSION=2.2.3

RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \ 
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      nodejs \
      openssl \
      pkgconfig \
      postgresql-dev \
      python \
      tzdata \
      yarn 

RUN gem install bundler -v 2.2.3

RUN mkdir /pet_tracking_app
WORKDIR /pet_tracking_app

COPY Gemfile /pet_tracking_app/Gemfile
COPY Gemfile.lock /pet_tracking_app/Gemfile.lock

RUN bundle install 

COPY . /pet_tracking_app
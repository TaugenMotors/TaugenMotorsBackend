FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /taugenMotors-Backend
WORKDIR /taugenMotors-Backend
ADD Gemfile /taugenMotors-Backend/Gemfile
ADD Gemfile.lock /taugenMotors-Backend/Gemfile.lock
RUN bundle install
ADD . /taugenMotors-Backend
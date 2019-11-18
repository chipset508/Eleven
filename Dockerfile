FROM ruby:2.4-slim-stretch

MAINTAINER devops@employmentinnovations.com

RUN apt-get update -qq --fix-missing \
  && apt-get install -y build-essential libpq-dev libxml2-dev libxslt1-dev cron git \
  && rm -rf /var/lib/apt/lists/* /tmp/*

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5 --without test

# Set Sinatra to run in production
ENV RACK_ENV production

# Copy the main application.
COPY . ./

EXPOSE 80

CMD ["bundle", "exec", "rackup", "-p", "80"]

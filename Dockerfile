FROM ruby:2.6.6

WORKDIR /app

RUN echo "deb http://ftp.us.debian.org/debian/ buster main" > /etc/apt/sources.list

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  curl \
  && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  && apt-get install -y nodejs \
  && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | tee /etc/apt/trusted.gpg.d/yarn.asc \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y yarn \
  && rm -rf /var/lib/apt/lists/*
RUN gem install nokogiri -v 1.13.10
RUN gem install rails -v 5.2.8.1

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

ENV RAILS_ENV=development
ENV RACK_ENV=development

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]


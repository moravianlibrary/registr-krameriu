FROM ruby:2.2.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN rm -rf /var/lib/apt/lists/*

ENV APP_HOME /usr/src/app

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* ./
RUN bundle install
ADD . $APP_HOME

RUN RAILS_ENV=production bundle exec rake assets:precompile --trace

CMD ["rails","server","-e","production","-b","0.0.0.0"]

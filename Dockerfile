FROM ruby:2.2.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs cron
RUN rm -rf /var/lib/apt/lists/*

ADD ./crontab /etc/cron.d/harvest
RUN chmod 0644 /etc/cron.d/harvest && chown root:root /etc/cron.d/harvest

ENV APP_HOME /usr/src/app

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* ./
RUN bundle install
ADD . $APP_HOME

RUN RAILS_ENV=production bundle exec rake assets:precompile --trace

EXPOSE 3000
CMD [ "bash","-c","cron && rails server -e production -b 0.0.0.0" ]

FROM ruby:3.4.2

WORKDIR /app

COPY . .

RUN bundle install

RUN bundle exec rake db:create db:migrate

CMD ["sh"]

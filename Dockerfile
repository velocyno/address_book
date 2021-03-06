FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

# Start the main process.
RUN bin/rails db:migrate
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
EXPOSE 3000


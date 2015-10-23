web: bundle exec rails server -p $PORT
scheduler: bundle exec rake resque:scheduler
worker: env TERM_CHILD=1 QUEUE='*' bundle exec rake resque:work
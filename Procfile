web: thin start -p $PORT
worker: env QUEUE='*' bundle exec rake resque:work
#!/bin/bash
set -e

cd chat-rails-api
# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

/usr/bin/wait-for-it.sh elasticsearch:9200 -t 0

rails db:create db:migrate db:seed
echo 'Message.reindex' | bundle exec rails c
bundle exec sidekiq &
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
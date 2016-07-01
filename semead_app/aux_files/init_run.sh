#!/bin/sh

# Initialize container on first run
if [ -z "$APP_INITIALIZED" ]; then

cd /home/app/semead
export RAILS_ENV=production
bundle exec rake db:migrate

# Consider yourself as initialized
echo "true" > /etc/container_environment/APP_INITIALIZED

fi

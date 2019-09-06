#!/bin/bash

source '.deploy/lib/deploy.sh'

if [ ! -f config/master.key ]; then
  if [ -z "$RAILS_PRODUCTION_KEY" ]; then
    echo "No rails master key"
    exit 1
  fi

  echo "$RAILS_PRODUCTION_KEY" > config/master.key
fi

deploy \
  --aws-access-key "$AWS_ACCESS_KEY_ID" \
  --aws-secret-key "$AWS_SECRET_ACCESS_KEY" \
  --region 'us-west-1' \
  --cluster 'backend-production' \
  --service 'backend' \
  --file '.deploy/production/docker-compose.yml' \
  --ecs_params '.deploy/production/ecs-params.yml' \
  --containers 'rails nginx'

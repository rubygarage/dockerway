#!/bin/bash

source '.deploy/lib/deploy.sh'

if [ ! -f config/credentials/staging.key ]; then
  if [ -z "$RAILS_STAGING_KEY" ]; then
    echo "No rails master key"
    exit 1
  fi

  echo "$RAILS_STAGING_KEY" > config/credentials/staging.key
fi

deploy \
  --aws-access-key "$AWS_ACCESS_KEY_ID" \
  --aws-secret-key "$AWS_SECRET_ACCESS_KEY" \
  --region 'us-west-1' \
  --cluster 'backend-staging' \
  --service 'backend' \
  --file '.deploy/staging/docker-compose.yml' \
  --ecs_params '.deploy/staging/ecs-params.yml' \
  --containers 'rails nginx'

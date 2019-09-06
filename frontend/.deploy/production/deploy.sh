source '.deploy/lib/deploy.sh'

deploy \
  --aws-access-key "$AWS_ACCESS_KEY_ID" \
  --aws-secret-key "$AWS_SECRET_ACCESS_KEY" \
  --region 'us-west-1' \
  --cluster 'frontend-production' \
  --service 'frontend'
  --file '.deploy/production/docker-compose.yml' \
  --ecs_params '.deploy/production/ecs-params.yml'

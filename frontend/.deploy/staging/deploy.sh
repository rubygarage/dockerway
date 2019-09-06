source '.deploy/lib/deploy.sh'

deploy \
  --aws-access-key "$AWS_ACCESS_KEY_ID" \
  --aws-secret-key "$AWS_SECRET_ACCESS_KEY" \
  --region 'us-west-1' \
  --cluster 'frontend-staging' \
  --service 'frontend' \
  --file '.deploy/staging/docker-compose.yml' \
  --ecs_params '.deploy/staging/ecs-params.yml'

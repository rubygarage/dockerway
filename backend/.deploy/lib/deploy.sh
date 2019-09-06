#!/bin/bash

# Required variables:
# - region # ECR Region
# - aws-access-key # AWS Access Id
# - aws-secret-key # AWS Secret Key
# - service # Service's name
# - cluster # Service's cluster
# - file # docker-compose file path
# - ecs_params # AWS ECS params file path
# - containers # container names for push to ECR

set -e

deploy() {
  while [[ $# -gt 0 ]]
  do
  key="$1"

  case $key in
      --region)
      REGION="$2"
      shift
      shift
      ;;
      --aws-access-key)
      AWS_ACCESS_KEY_ID="$2"
      shift
      shift
      ;;
      --aws-secret-key)
      AWS_SECRET_ACCESS_KEY="$2"
      shift
      shift
      ;;
      --cluster)
      CLUSTER="$2"
      shift
      shift
      ;;
      --file)
      FILE="$2"
      shift
      shift
      ;;
      --service)
      SERVICE="$2"
      shift
      shift
      ;;
      --ecs_params)
      ECS_PARAMS="$2"
      shift
      shift
      ;;
      --containers)
      CONTAINERS="$2"
      shift
      shift
      ;;
      *)
      echo "Unknown option $1\n"
      shift
      shift
  esac
  done

  export TAG=$(git log -1 --format=%h)
  export REGION=$REGION

  echo "🐳  Build docker image $BUILD_APP"
  push_to_docker

  echo "🚀  Deploy $BUILD_APP to $CLUSTER:$SERVICE"
  ecs_deploy

  echo '✅  Deploy successfully finished'
}

push_to_docker() {
  $(aws ecr get-login --region $REGION --no-include-email)

  docker-compose -f $FILE build $CONTAINERS
  docker-compose -f $FILE push $CONTAINERS
}

ecs_deploy() {
  ecs-cli configure \
    --cluster $CLUSTER \
    --region $REGION \
    --default-launch-type EC2 \
    --config-name $CLUSTER

  ecs-cli compose \
    --project-name $SERVICE \
    --file $FILE \
    --ecs-params $ECS_PARAMS \
    service up \
    --cluster-config $CLUSTER \
    --force-deployment \
    --timeout 2
}

exec "$@"

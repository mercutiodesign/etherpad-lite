#!/bin/sh
set -a && . "$(dirname $0)/.env" || exit 1
set -ex
for service in etherpad; do
  docker pull $ECRHOST/etherpad-lite_$service:latest
  docker tag $ECRHOST/etherpad-lite_$service:latest etherpad-lite_$service:latest
done;

docker-compose up -d --no-build

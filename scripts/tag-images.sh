#!/bin/sh
set -a && . "$(dirname $0)/.env" || exit 1
set -ex
for service in etherpad; do
  docker tag etherpad-lite_$service:latest $ECRHOST/etherpad-lite_$service:latest
  docker push $ECRHOST/etherpad-lite_$service:latest
done;

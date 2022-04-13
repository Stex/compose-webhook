#!/usr/bin/env bash

[ -n "$DOCKER_LOGIN" ] && docker login $REGISTRY_URL -u $REGISTRY_USER -p $REGISTRY_TOKEN
exec "$@"

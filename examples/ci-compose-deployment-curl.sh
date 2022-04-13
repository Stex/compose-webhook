#!/usr/bin/env bash

set -euo pipefail

WEBHOOK_URL=$1/hooks/ci-compose-deployment
PAYLOAD="{\"branch\": \"$2\"}"
SIGNATURE=$(echo -n $PAYLOAD | openssl sha1 -hmac $HMAC_SECRET)

curl \
  --header "Content-Type: application/json" \
  --header "X-Signature: $SIGNATURE" \
  --request POST \
  --data "$PAYLOAD" \
  $WEBHOOK_URL

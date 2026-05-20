#!/usr/bin/env sh
set -eu

: "${CLOUDFLARE_API_TOKEN:?Set CLOUDFLARE_API_TOKEN with permission to edit R2 buckets.}"
: "${CLOUDFLARE_ACCOUNT_ID:?Set CLOUDFLARE_ACCOUNT_ID.}"

BUCKET_NAME="${R2_STATE_BUCKET:-lanilsen-terraform-state}"

curl -fsS -X PUT \
  "https://api.cloudflare.com/client/v4/accounts/${CLOUDFLARE_ACCOUNT_ID}/r2/buckets/${BUCKET_NAME}" \
  -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
  -H "Content-Type: application/json" \
  --data '{"storageClass":"Standard"}'

printf '\nCreated or verified R2 bucket: %s\n' "$BUCKET_NAME"
printf 'S3 endpoint: https://%s.r2.cloudflarestorage.com\n' "$CLOUDFLARE_ACCOUNT_ID"

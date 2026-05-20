#!/usr/bin/env sh
set -eu

: "${CLOUDFLARE_ACCOUNT_ID:?Set CLOUDFLARE_ACCOUNT_ID.}"

BUCKET_NAME="${R2_STATE_BUCKET:-lanilsen-terraform-state}"
STATE_KEY="${R2_STATE_KEY:-terraform-proxmox/proxmox-core/terraform.tfstate}"

cat > backend.r2.tfbackend <<EOF
bucket                      = "${BUCKET_NAME}"
key                         = "${STATE_KEY}"
region                      = "auto"
endpoints                   = { s3 = "https://${CLOUDFLARE_ACCOUNT_ID}.r2.cloudflarestorage.com" }
use_lockfile                = true
skip_credentials_validation = true
skip_metadata_api_check     = true
skip_region_validation      = true
skip_requesting_account_id  = true
skip_s3_checksum            = true
use_path_style              = true
EOF

chmod 600 backend.r2.tfbackend
printf 'Wrote backend.r2.tfbackend for bucket %s key %s\n' "$BUCKET_NAME" "$STATE_KEY"

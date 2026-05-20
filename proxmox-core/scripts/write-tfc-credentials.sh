#!/usr/bin/env sh
set -eu

if [ "${TF_TOKEN_app_terraform_io:-}" = "" ]; then
  printf 'Enter HCP Terraform token: ' >&2
  stty -echo
  read -r TF_TOKEN_app_terraform_io
  stty echo
  printf '\n' >&2
fi

mkdir -p "$HOME/.terraform.d"
umask 077
cat > "$HOME/.terraform.d/credentials.tfrc.json" <<EOF
{
  "credentials": {
    "app.terraform.io": {
      "token": "$TF_TOKEN_app_terraform_io"
    }
  }
}
EOF

chmod 600 "$HOME/.terraform.d/credentials.tfrc.json"
printf 'Wrote %s\n' "$HOME/.terraform.d/credentials.tfrc.json"

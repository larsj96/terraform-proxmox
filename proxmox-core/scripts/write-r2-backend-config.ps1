param(
  [Parameter(Mandatory = $false)]
  [string] $BucketName = $(if ($env:R2_STATE_BUCKET) { $env:R2_STATE_BUCKET } else { "lanilsen-terraform-state" }),

  [Parameter(Mandatory = $false)]
  [string] $StateKey = $(if ($env:R2_STATE_KEY) { $env:R2_STATE_KEY } else { "terraform-proxmox/proxmox-core/terraform.tfstate" }),

  [Parameter(Mandatory = $false)]
  [string] $AccountId = $env:CLOUDFLARE_ACCOUNT_ID
)

if (-not $AccountId) {
  throw "Set CLOUDFLARE_ACCOUNT_ID."
}

@"
bucket                      = "$BucketName"
key                         = "$StateKey"
region                      = "auto"
endpoints                   = { s3 = "https://$AccountId.r2.cloudflarestorage.com" }
use_lockfile                = true
skip_credentials_validation = true
skip_metadata_api_check     = true
skip_region_validation      = true
skip_requesting_account_id  = true
skip_s3_checksum            = true
use_path_style              = true
"@ | Set-Content -Path "backend.r2.tfbackend" -Encoding utf8NoBOM

Write-Host "Wrote backend.r2.tfbackend for bucket $BucketName key $StateKey"

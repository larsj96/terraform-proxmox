param(
  [Parameter(Mandatory = $false)]
  [string] $BucketName = $(if ($env:R2_STATE_BUCKET) { $env:R2_STATE_BUCKET } else { "lanilsen-terraform-state" }),

  [Parameter(Mandatory = $false)]
  [string] $AccountId = $env:CLOUDFLARE_ACCOUNT_ID,

  [Parameter(Mandatory = $false)]
  [string] $ApiToken = $env:CLOUDFLARE_API_TOKEN
)

if (-not $AccountId) {
  throw "Set CLOUDFLARE_ACCOUNT_ID."
}

if (-not $ApiToken) {
  throw "Set CLOUDFLARE_API_TOKEN with permission to edit R2 buckets."
}

$uri = "https://api.cloudflare.com/client/v4/accounts/$AccountId/r2/buckets/$BucketName"
$headers = @{
  Authorization = "Bearer $ApiToken"
  "Content-Type" = "application/json"
}

Invoke-RestMethod -Method Put -Uri $uri -Headers $headers -Body '{"storageClass":"Standard"}' | Out-Null
Write-Host "Created or verified R2 bucket: $BucketName"
Write-Host "S3 endpoint: https://$AccountId.r2.cloudflarestorage.com"

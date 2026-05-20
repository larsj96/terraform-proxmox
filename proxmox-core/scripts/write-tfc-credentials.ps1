param(
  [Parameter(Mandatory = $false)]
  [string] $Token = $env:TF_TOKEN_app_terraform_io
)

if (-not $Token) {
  $secure = Read-Host -Prompt "Enter HCP Terraform token" -AsSecureString
  $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
  try {
    $Token = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
  }
  finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
  }
}

$terraformDir = Join-Path $HOME ".terraform.d"
$credentialsPath = Join-Path $terraformDir "credentials.tfrc.json"
New-Item -ItemType Directory -Force -Path $terraformDir | Out-Null

$credentials = @{
  credentials = @{
    "app.terraform.io" = @{
      token = $Token
    }
  }
}

$credentials | ConvertTo-Json -Depth 5 | Set-Content -Path $credentialsPath -Encoding utf8NoBOM
Write-Host "Wrote $credentialsPath"

$ErrorActionPreference = "Stop"

Write-Host "Running unit tests..."
Push-Location "$PSScriptRoot\..\services\backend"
npm run lint
node --test --experimental-test-coverage
Pop-Location

Push-Location "$PSScriptRoot\..\services\frontend"
npm run lint
node --test --experimental-test-coverage
Pop-Location

Write-Host "Validating Terraform formatting and syntax..."
Push-Location "$PSScriptRoot\..\terraform"
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
Pop-Location

Write-Host "All local validations passed."

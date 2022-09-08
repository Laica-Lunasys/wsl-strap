$ErrorActionPreference = "stop"

Set-Location $PSScriptRoot

$userenv = [System.Environment]::GetEnvironmentVariable("Path", "User")
[System.Environment]::SetEnvironmentVariable("PATH", $userenv + ";$(Get-Location)\bin\", "User")
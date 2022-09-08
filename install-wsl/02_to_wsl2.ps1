$WindowsPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-Not($WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))){
    Write-Output "Must be Administrator."
    Exit
}
$erroractionpreference = "stop"
Set-Location $PSScriptRoot

Write-Output ":: Install WSL2..."
# mkdir .\tmp
Set-Location .\tmp
Invoke-WebRequest -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile wsl_update_x64.msi -UseBasicParsing
msiexec /i wsl_update_x64.msi /passive /norestart
wsl --set-default-version 2
# Remove-Item wsl_update_x64.msi
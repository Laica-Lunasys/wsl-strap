$ErrorActionPreference = "stop"

Set-Location $PSScriptRoot
$WindowsPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-Not($WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))) {
    Write-Output "Must be Administrator."
    Exit
}

# Set-VMSwitch -Name "WSL" -SwitchType External -NetAdapterName (Get-NetAdapter |?{$_.Status -eq "Up" -and $_.NdisPhysicalMedium -eq 14}).Name

New-VMSwitch -Name "WSLBridge" -NetAdapterName (Get-NetAdapter |?{$_.Status -eq "Up" -and $_.NdisPhysicalMedium -eq 14}).Name -AllowManagementOS $true
# Set-VMSwitch -Name "WSL" -SwitchType Internal 
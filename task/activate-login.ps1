$ErrorActionPreference = "stop"

Set-Location $PSScriptRoot
$WindowsPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-Not($WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))) {
    Write-Output "Must be Administrator."
    Exit
}

if (Get-ScheduledTask -TaskPath "\Laica-Lunasys\WSL-Strap\*" -TaskName "Init WSL Environment") {
    Unregister-ScheduledTask -TaskPath "\Laica-Lunasys\WSL-Strap\*" -TaskName "Init WSL Environment" -Confirm:$false
}

$Trigger = New-ScheduledTaskTrigger -AtLogon -User $(whoami.exe)
$Action = New-ScheduledTaskAction -Execute "$(Get-Location)\onStart.bat"
Register-ScheduledTask -TaskPath "\Laica-Lunasys\WSL-Strap" -TaskName "Init WSL Environment" -RunLevel Highest -Trigger $Trigger -Action $Action
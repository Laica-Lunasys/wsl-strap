Param (
    [parameter(mandatory = $false)]$withoutDocker = $false
)

$ErrorActionPreference = "stop"

Set-Location $PSScriptRoot
$WindowsPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-Not($WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))) {
    Write-Output "Must be Administrator."
    Exit
}

Set-Location .\..

# --- Load Config ---
$config = Get-Content .\config.json | ConvertFrom-Json

$name = $config.name
$staticIP = $config.staticIP
$ports = $config.ports
$services = $config.services
# ---

Write-Output ":: Distribution: $name"
Write-Output ":: Forward ports: [$ports]"

# Docker
if (-not($withoutDocker)) {
    if (tasklist.exe | Select-String "Docker Desktop.exe") {
        Write-Output ":: Restarting Docker..."
        Start-Process -NoNewWindow -Wait "$Env:ProgramFiles\Docker\Docker\DockerCli.exe" '-Shutdown'
        Start-Process -NoNewWindow -Wait "$Env:ProgramFiles\Docker\Docker\DockerCli.exe" '-SwitchLinuxEngine'
    }
    else {
        Write-Output ":: Starting Docker..."
        Start-Process -WindowStyle Hidden -Wait "$Env:ProgramFiles\Docker\Docker\Docker Desktop.exe"
    }
}

# Start X Server
if (Test-Path C:\Program` Files\VcXsrv\xlaunch.exe) {
    if (tasklist.exe | Select-String "vcxsrv.exe") {
        Write-Output ":: Stopping VcXsrv..."
        taskkill /f /im vcxsrv.exe
        Start-Sleep 1
    }
    Write-Output ":: Starting VcXsrv @ $PSScriptRoot..."
    C:\Program` Files\VcXsrv\xlaunch.exe -run .\x11\config.xlaunch
}

# Static-IP
powershell .\utils\static-ip.ps1 -DistName $name

# Enable Port forward
if ($ports) {
    foreach ($port in $ports) {
        powershell .\utils\port-forward.ps1 add $staticIP $port
    }
    powershell .\utils\port-forward.ps1 show
}

# Start service
if ($services) {
    foreach ($service in $services) {
        wsl -d $name -u root service $service start
    }
}

# Wait...
Write-Output ':: Close after 3 seconds...'
Start-Sleep 3
$ErrorActionPreference = "stop"

Set-Location $PSScriptRoot
$WindowsPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-Not($WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))) {
    Write-Output "Must be Administrator."
    Exit
}

# --- Load Config ---
$config = Get-Content .\config.json | ConvertFrom-Json

$name = $config.name
$staticIP = $config.staticIP
$ports = $config.ports
$services = $config.services
# ---

Write-Output ":: Distribution: $name"
Write-Output ":: Forward ports: [$ports]"

# Start X Server
if (Test-Path C:\Program` Files\VcXsrv\xlaunch.exe) {
    Write-Output ":: Starting VcXsrv @ $PSScriptRoot..."
    if (tasklist.exe | Select-String "vcxsrv.exe") {
        Write-Output ":: Stopping VcXsrv..."
        taskkill /im vcxsrv.exe
        Start-Sleep 1
    }
    
    C:\Program` Files\VcXsrv\xlaunch.exe -run $PSScriptRoot\x11\config.xlaunch
}

# Static-IP
powershell $PSScriptRoot\utils\static-ip.ps1 -DistName $name

# Enable Port forward
if ($ports) {
    foreach ($port in $ports) {
        powershell $PSScriptRoot\utils\port-forward.ps1 add $staticIP $port
    }
    powershell $PSScriptRoot\utils\port-forward.ps1 show
}

# Start service
if ($services) {
    foreach ($service in $services) {
        wsl -d $name -u root service $service start
    }
}
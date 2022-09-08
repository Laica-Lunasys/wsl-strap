Param (
    $Action,
    [parameter(mandatory = $false)]$withoutDocker = "false"
)

$ErrorActionPreference = "stop"

Set-Location $PSScriptRoot
Set-Location .\..
# $WindowsPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
# if (-Not($WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))) {
#     Write-Output "Must be Administrator."
#     Exit
# }

# --- Load Config ---
$config = Get-Content .\config.json | ConvertFrom-Json

$name = $config.name
$staticIP = $config.staticIP
$x11 = $config.x11
$init = $config.init
# ---

Write-Output "Distribution: $name"

if ($Action -eq "start") {
    # Static IP Forward
    if ($staticIP.enable) {
        Write-Output "[IPFwd] IP-Forward ports: [$($staticIP.ports)]"
        powershell .\utils\static-ip.ps1 -DistName $name
    
        # Enable Port forward
        if ($staticIP.ports) {
            foreach ($port in $staticIP.ports) {
                powershell .\utils\port-forward.ps1 add $staticIP $port
            }
            powershell .\utils\port-forward.ps1 show
        }
    } else {
        Write-Output "[IPFwd] Skip IP-Forward"
    }
    
    # Start X Server
    if ($x11.enable) {
        Write-Output "[X11] Start X11..."
        powershell .\utils\startx.ps1 start
    } else {
        Write-Output "[X11] Skip X11"
    }
    
    # Start service
    if ($init.enable) {
        Write-Output "[INIT] Start Init process..."
        wsl -d $name -u root uname -a
    
        if ($init.services) {
            if ($init.as -eq "systemd") {
                Start-Sleep 1
                foreach ($service in $services) {
                    wsl -d $name -u root systemctl is-active $service
                }
    
                wsl -d $name -u root systemctl list-units --state=running --legend=false --no-pager
            }
        }
    }
    
    # Wait...
    Write-Output ':: Close after 3 seconds...'
    Start-Sleep 3
} elseif ($Action -eq "stop") {
    wsl -t $name
    powershell .\utils\startx.ps1 stop
} else {
    Write-Output "wsl-strap <start|stop>"
}
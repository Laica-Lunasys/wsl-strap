Param (
    $Action,
    [parameter(mandatory = $false)]$withoutDocker = "false"
)

$ErrorActionPreference = "stop"

Set-Location $PSScriptRoot
Set-Location .\..

function Stop-X11() {
    if (Test-Path $Env:ProgramFiles\VcXsrv\xlaunch.exe) {
        if (tasklist.exe | Select-String "vcxsrv.exe") {
            Write-Output "* Stopping VcXsrv..."
            taskkill /f /im vcxsrv.exe
            Start-Sleep 1
        }
    } else {
        Write-Error "E: vcxsrv.exe does not exists."
        exit
    }
}

if ($Action -eq "start") {
    Stop-X11
    if (Test-Path $Env:ProgramFiles\VcXsrv\xlaunch.exe) {
        if (-not (Test-Path "$(Get-Location)\x11\config.xlaunch")) {
            Write-Error "E: config.xlaunch not found."
            exit 1
        }
    
        Write-Output "* Starting VcXsrv @ $(Get-Location)..."
        Start-Process "$Env:ProgramFiles\VcXsrv\xlaunch.exe" -ArgumentList '-run .\x11\config.xlaunch'
    } else {
        Write-Error "E: vcxsrv.exe does not exists."
        exit
    }
} elseif ($Action -eq "stop") {
    Stop-X11
}

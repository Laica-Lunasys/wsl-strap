Write-Output ":: Starting VcXsrv @ $PSScriptRoot..."
if (tasklist.exe | Select-String "vcxsrv.exe") {
    Write-Output ":: Stopping VcXsrv..."
    taskkill /f /im vcxsrv.exe
    Start-Sleep 1
}

C:\Program` Files\VcXsrv\xlaunch.exe -run $PSScriptRoot\x11\config.xlaunch

powershell $PSScriptRoot\static-ip.ps1
powershell $PSScriptRoot\port-forward.ps1

powershell $PSScriptRoot\start-service.ps1
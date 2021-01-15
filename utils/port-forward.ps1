Param(
    [parameter(mandatory=$true)]$Action,
    [parameter(mandatory=$false)]$Address,
    [parameter(mandatory=$false)]$Port
)

function Request-Admin {
    $WindowsPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    if (-Not($WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))){
        Write-Output "Must be Administrator."
        Exit
    }
}

function Add-PortForward($Address, $Port) {
    Request-Admin
    Write-Output ":: Add PortProxy (-> ${Address}:${Port})"
    netsh.exe interface portproxy add v4tov4 listenport=$Port connectaddress=$Address
}

function Remove-PortForward($Address, $Port) {
    Request-Admin
    Write-Output ":: Remove PortProxy (-> ${Address}:${Port})"
    netsh.exe interface portproxy delete v4tov4 listenport=$Port connectaddress=$Address
}

function Show-PortForward {
    Request-Admin
    netsh.exe interface portproxy show v4tov4
}

if ($Action -eq "add") {
    Add-PortForward $Address $Port
} elseif ($Action -eq "remove") {
    Remove-PortForward $Address $Port
} elseif ($Action -eq "show") {
    Show-PortForward
} else {
    Write-Error("E: Unknown action")
}
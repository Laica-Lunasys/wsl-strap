Param(
    [parameter(mandatory = $true)]$Port,
    [parameter(mandatory = $false)]$Protocol = "TCP"
)

$WindowsPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-Not($WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))) {
    Write-Output "Must be Administrator."
    Exit
}
$erroractionpreference = "stop"

if ($Rule = Get-NetFirewallRule -DisplayName WSL-Strap -ErrorAction 'SilentlyContinue') {
    Write-Output "Exists"
    Remove-NetFirewallRule -Name $Rule.Name
}

New-NetFirewallRule -DisplayName "WSL-Strap_$Protocol" -Direction Inbound -LocalPort $Port -Action Allow -Protocol $Protocol
New-NetFirewallRule -DisplayName "WSL-Strap_$Protocol" -Direction Outbound -LocalPort $Port -Action Allow -Protocol $Protocol
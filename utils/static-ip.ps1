Param(
    [parameter(mandatory = $true)]$DistName,
    [parameter(mandatory = $false)]$HostAddress = "192.168.55.1",
    [parameter(mandatory = $false)]$IPAddress = "192.168.55.70",
    [parameter(mandatory = $false)]$BroadcastAddress = "192.168.50.255"
)

$WindowsPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-Not($WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))) {
    Write-Output "Must be Administrator."
    Exit
}
$erroractionpreference = "stop"

$TargetInterface = "vEthernet (WSL)"

# ---
# Bind to Host ($HostAddress -> host)
# netsh interface ip add address "vEthernet (WSL)" $HostAddress 255.255.255.0
# Check: netsh interface ip show addresses
# without netsh help: Get-Command -Module NetTCPIP
$Timeout = 60
$ElapsedTime = 0
Write-Output ":: Waiting Interface Up..."
while (!(Get-NetIPAddress -InterfaceAlias $TargetInterface -ErrorAction 'SilentlyContinue')) {
    if ($ElapsedTime -gt $Timeout) {
        Write-Output "!! E: Interface configure timed out"
        Write-Output "!! E: Please check configure correctly: $TargetInterface"
        Write-Error "Failed detect interface"
    }
    Start-Sleep 1
    $ElapsedTime += 1
}

if (Get-NetIPAddress -InterfaceAlias $TargetInterface -AddressFamily IPv4 | Where-Object { $_.IPAddress -eq $HostAddress }) {
    Write-Output "-- Already binded?"
}
else {
    Write-Output ":: Add IP..."
    New-NetIPAddress -InterfaceAlias $TargetInterface -AddressFamily IPv4 -IPAddress $HostAddress -PrefixLength 24
}

# Set Static IP for WSL2 Environment
wsl -d $DistName -u root ip addr add $IPAddress/24 broadcast $BroadcastAddress dev eth0 label eth0:1

# OR GET:
# Get-NetIPAddress -InterfaceAlias "vEthernet (WSL)" | Format-Table

# OR DELETE:
# Remove-NetIPAddress -InterfaceAlias "vEthernet (WSL)" -AddressFamily IPv4 -IPAddress $HostAddress
# ip addr delete $IPAddress/24 dev eth0
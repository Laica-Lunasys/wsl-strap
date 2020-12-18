$WindowsPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-Not($WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))){
    Write-Output "Must be Administrator."
    Exit
}

# ---
# Bind to Host (192.168.55.1 -> host)
# netsh interface ip add address "vEthernet (WSL)" 192.168.55.1 255.255.255.0
# Check: netsh interface ip show addresses
# without netsh help: Get-Command -Module NetTCPIP

$targetDist = "Groovy"
if (Get-NetIPAddress -InterfaceAlias "vEthernet (WSL)" -AddressFamily IPv4 | Where-Object { $_.IPAddress -eq "192.168.55.1" }) {
    Write-Output "-- Already binded?"
} else {
    Write-Output ":: Add IP..."
    New-NetIPAddress -InterfaceAlias "vEthernet (WSL)" -AddressFamily IPv4 -IPAddress 192.168.55.1 -PrefixLength 24
}

# Set Static IP for WSL2 Environment
wsl -d $targetDist -u root ip addr add 192.168.55.70/24 broadcast 192.168.50.255 dev eth0 label eth0:1

# OR GET:
# Get-NetIPAddress -InterfaceAlias "vEthernet (WSL)" | Format-Table

# OR DELETE:
# Remove-NetIPAddress -InterfaceAlias "vEthernet (WSL)" -AddressFamily IPv4 -IPAddress 192.168.55.1
# ip addr delete 192.168.55.70/24 dev eth0
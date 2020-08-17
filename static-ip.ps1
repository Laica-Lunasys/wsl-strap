# ---
# Bind to Host (192.168.55.1 -> host)
# netsh interface ip add address "vEthernet (WSL)" 192.168.55.1 255.255.255.0
# Check: netsh interface ip show addresses
# without netsh help: Get-Command -Module NetTCPIP

$targetDist = "Ubuntu"
New-NetIPAddress -InterfaceAlias "vEthernet (WSL)" -AddressFamily IPv4 -IPAddress 192.168.55.1 -PrefixLength 24

# Set Static IP for WSL2 Environment
wsl -d $targetDist -u root ip addr add 192.168.55.70/24 broadcast 192.168.50.255 dev eth0 label eth0:1

# OR GET:
# Get-NetIPAddress -InterfaceAlias "vEthernet (WSL)" | Format-Table

# OR DELETE:
# Remove-NetIPAddress -InterfaceAlias "vEthernet (WSL)" -AddressFamily IPv4 -IPAddress 192.168.55.1
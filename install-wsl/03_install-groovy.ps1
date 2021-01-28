Param(
    [parameter(mandatory=$true)]$TargetUser,
    [parameter(mandatory=$true)]$DistName,
    [parameter(mandatory=$true)]$TargetDir
)

$WindowsPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-Not($WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))){
    Write-Output "Must be Administrator."
    Exit
}
$erroractionpreference = "stop"

$URL = "https://partner-images.canonical.com/core/groovy/current/ubuntu-groovy-core-cloudimg-amd64-root.tar.gz"
$FileName = "Ubuntu.tar.gz"

# Install
mkdir -Force $TargetDir
Set-Location $TargetDir
Invoke-WebRequest -Uri $URL -OutFile $FileName -UseBasicParsing
Start-Sleep 5
wsl --import $DistName $TargetDir $FileName
Remove-Item -Force $FileName

# Initial setup
wsl -d $DistName -u root apt update
wsl -d $DistName -u root apt install -y sudo nano wget curl iproute2 locales
wsl -d $DistName -u root apt install -y neovim tmux zsh git python3 python3-pip nodejs npm golang
wsl -d $DistName -u root npm install -g yarn

# Install wsl-open via npm
wsl -d $DistName -u root npm install -g wsl-open '&&' ln -s /usr/local/bin/wsl-open /usr/local/bin/open

# Update locale
wsl -d $DistName -u root sed -i -E 's/# (en_US.UTF-8)/\1/' /etc/locale.gen
wsl -d $DistName -u root sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen
wsl -d $DistName -u root locale-gen

# Create User
wsl -d $DistName useradd -m -s /bin/bash -g sudo $TargetUser
wsl -d $DistName passwd $TargetUser

# Set default user
Set-Location $PSScriptRoot
..\utils\default-user.ps1 $DistName $TargetUser
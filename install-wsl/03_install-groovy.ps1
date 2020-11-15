$WindowsPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-Not($WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))){
    Write-Output "Must be Administrator."
    Exit
}

$TargetUser = "laica"

$DistName = "Groovy"
$URL = "https://partner-images.canonical.com/core/groovy/current/ubuntu-groovy-core-cloudimg-amd64-root.tar.gz"
$FileName = "Ubuntu-Groovy.tar.gz"
$TargetDir = "R:\wsl"

# Install
Set-Location $TargetDir
Invoke-WebRequest -Uri $URL -OutFile $FileName -UseBasicParsing
wsl --import $DistName $TargetDir $FileName

# Initial setup
wsl -d $DistName -u root apt update
wsl -d $DistName -u root apt install -y sudo nano wget curl iproute2 locales
wsl -d $DistName -u root apt install -y neovim tmux zsh git python3 python3-pip nodejs npm yarnpkg golang

# Update locale
wsl -d $DistName -u root sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen
wsl -d $DistName -u root locale-gen

# Install wsl-open via npm
wsl -d $DistName -u root npm install -g wsl-open '&&' ln -s /usr/local/bin/wsl-open /usr/local/bin/open

# Create User
wsl -d $DistName useradd -m -s /bin/bash -g sudo $TargetUser
wsl -d $DistName passwd $TargetUser
Write-Output "Must be Add in WSL2 (/etc/wsl.conf):"
Write-Output "[user]"
Write-Output "default=$TargetUser"

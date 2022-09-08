$erroractionpreference = "stop"
$DistributionName = "ubuntu"
$PackName = "ubuntu-22.04-extra"
$TargetUserName = $env:UserName.replace('.', '-')

Set-Location $PSScriptRoot

if (-not(Test-Path -Path "$($env:USERPROFILE)\wsl")) {
    mkdir $env:USERPROFILE\wsl
}

if (Test-Path -Path "$($env:USERPROFILE)\wsl\ext4.vhdx") {
    Write-Output "Seems already install..."
    exit 1
}

powershell ..\pack-gen.ps1 -PackName $PackName

powershell ..\pack-install.ps1 `
    -DistName $DistributionName `
    -PackDir ..\generated\${PackName}.tar `
    -TargetUser ${TargetUserName} `
    -TargetDir ${env:USERPROFILE}\wsl

powershell ..\utils\default-user.ps1 `
    -DistributionName $DistributionName `
    -UserName ${TargetUserName}

wsl -d $DistributionName -u root usermod -aG sudo ${TargetUserName}
wsl -d $DistributionName -u root -- chsh -s /bin/zsh ${TargetUserName}

wsl -d $DistributionName -u ${TargetUserName} --cd ~ -- git clone https://github.com/Laica-Lunasys/dotfiles.git
wsl -d $DistributionName -u ${TargetUserName} --cd /home/${TargetUserName}/dotfiles -- make clean install
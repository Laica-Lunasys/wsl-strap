Param(
    [parameter(mandatory=$true)]$TargetUser,
    [parameter(mandatory=$true)]$DistName,
    [parameter(mandatory=$true)]$TargetDir
)

# $WindowsPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
# if (-Not($WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))){
#     Write-Output "Must be Administrator."
#     Exit
# }
$ErrorActionPreference = "stop"

Set-Location $PSScriptRoot

# Make from docker image
$docker_image = "wsl-strap/${DistName}"
$tmp_container_name = "wsl-strap_tmp_${DistName}"
docker build . -t $docker_image
docker export $(docker create --name ${tmp_container_name} $docker_image) -o "${DistName}.tar"
wsl --import $DistName $TargetDir "${DistName}.tar"
docker rm ${tmp_container_name}
Remove-Item -Force "${DistName}.tar"

# Create User
wsl -d $DistName useradd -m -s /bin/bash -G sudo $TargetUser
wsl -d $DistName passwd $TargetUser

# Set default user
Set-Location $PSScriptRoot
..\..\utils\default-user.ps1 $DistName $TargetUser
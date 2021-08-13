Param(
    [parameter(mandatory=$true)]$PackName,
    [parameter(mandatory=$true)]$TargetUser,
    [parameter(mandatory=$true)]$DistName,
    [parameter(mandatory=$true)]$TargetDir
)

# $WindowsPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
# if (-Not($WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))){
#     Write-Output "Must be Administrator."
#     Exit
# }
$erroractionpreference = "stop"

Set-Location $PSScriptRoot
Set-Location .\pack\${PackName}

# Make from docker image
$docker_image = "wsl-strap/${DistName}"
$tmp_container_name = "wsl-strap_tmp_${DistName}"
docker build . -t $docker_image --progress plain
if (!$?) {
    Write-Output "Failed to build docker image"
    exit 1
}

docker export $(docker create --name ${tmp_container_name} $docker_image) -o "${DistName}.tar"
if (!$?) {
    Write-Output "Failed to export docker image"
    exit 1
}

wsl --import $DistName $TargetDir "${DistName}.tar"
if (!$?) {
    Write-Output "Failed to import from docker image"
    exit 1
}

docker rm ${tmp_container_name}
Remove-Item -Force "${DistName}.tar"

# Create User
wsl -d $DistName useradd -m -s /bin/bash -G sudo $TargetUser
wsl -d $DistName passwd $TargetUser

# Set default user
Set-Location $PSScriptRoot
.\utils\default-user.ps1 $DistName $TargetUser
Param(
    [parameter(mandatory=$true)]$PackName,
    [parameter(mandatory=$false)]$TargetDir
)

$erroractionpreference = "stop"

Set-Location $PSScriptRoot
Set-Location .\pack\${PackName}

$docker_image = "wsl-strap/${PackName}"
$tmp_container_name = "wsl-strap_tmp_${PackName}"
Write-Output ":: Build base image..."
docker build . -t $docker_image --progress=plain --pull
if (!$?) {
    Write-Output "Failed to build docker image"
    exit 1
}

Write-Output ":: Export tarball from container..."
if ($null -ne $TargetDir) {
    mkdir -Force $TargetDir
    Set-Location $TargetDir
} else {
    mkdir -Force $PSScriptRoot/generated
    Set-Location $PSScriptRoot/generated
}

$export_directory = Get-Location
docker export $(docker create --name ${tmp_container_name} $docker_image) -o "${PackName}.tar"
if (!$?) {
    Write-Output "Failed to export docker image"
    exit 1
}

Write-Output ":: Remove template container"
docker rm ${tmp_container_name}
if (!$?) {
    Write-Output "Failed to clean-up container"
    exit 1
}

Write-Output ":: Generated Package: ${PackName}.tar"
Write-Output "Try: ./pack-install.ps1 -DistName ${PackName} -PackDir ${export_directory}\${PackName}.tar -TargetUser ${env:UserName} -TargetDir C:\wsl\${PackName}"
Set-Location $PSScriptRoot
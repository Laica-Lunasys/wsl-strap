Param(
    [parameter(mandatory=$true)]$DistName,
    [parameter(mandatory=$true)]$PackDir,
    [parameter(mandatory=$true)]$TargetUser,
    [parameter(mandatory=$true)]$TargetDir
)

# $WindowsPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
# if (-Not($WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))){
#     Write-Output "Must be Administrator."
#     Exit
# }
$erroractionpreference = "stop"

Set-Location $PSScriptRoot

Write-Output ":: Importing tarball..."
mkdir -Force $TargetDir
wsl --import $DistName $TargetDir $PackDir
if (!$?) {
    Write-Output "Failed to import from package"
    exit 1
}

# Create User
Write-Output ":: Create user..."
wsl -u root -d $DistName -- eval 'if [ "$(which useradd &> /dev/null; echo $?)" != 0 ]; then exit 1; fi'
if ($?) {
    wsl -u root -d $DistName useradd -m $TargetUser
} else {
    Write-Output "!! useradd command not found. try another..."
    wsl -u root -d $DistName -- eval 'if [ "$(which adduser &> /dev/null; echo $?)" != 0 ]; then exit 1; fi'
    if ($?) {
        wsl -u root -d $DistName adduser -D $TargetUser 
    } else {
        Write-Output "E: Failed create user."
        exit 1
    }
}
wsl -d $DistName passwd $TargetUser

# Set default user
Set-Location $PSScriptRoot
.\utils\default-user.ps1 $DistName $TargetUser
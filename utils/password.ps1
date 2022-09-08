Param(
    [parameter(mandatory = $true)]$DistName,
    [parameter(mandatory = $true)]$TargetUser
)

do {
    wsl -d $DistName -u root passwd $TargetUser
    $SetPasswordStatus = $?
    if (!$SetPasswordStatus) {
        Write-Output "Unable to change password, Try again? (Ctrl+C to abort)"
        Pause
    }
} while (!$SetPasswordStatus)
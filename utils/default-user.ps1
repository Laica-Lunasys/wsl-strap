Param(
    [parameter(mandatory=$true)]$DistributionName,
    [parameter(mandatory=$true)]$UserName
)

Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | Where-Object -Property DistributionName -eq $DistributionName | Set-ItemProperty -Name DefaultUid -Value ((wsl -d $DistributionName -u $UserName -e id -u) | Out-String); 
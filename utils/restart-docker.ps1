if (tasklist.exe | Select-String "Docker Desktop.exe") {
    Start-Process -NoNewWindow -Wait "$Env:ProgramFiles\Docker\Docker\DockerCli.exe" -ArgumentList ['-Shutdown']
    Start-Process -NoNewWindow -Wait "$Env:ProgramFiles\Docker\Docker\DockerCli.exe" -ArgumentList ['-SwitchLinuxEngine']
}
else {
    Start-Process -WindowStyle Hidden -Wait "$Env:ProgramFiles\Docker\Docker\Docker Desktop.exe"
}
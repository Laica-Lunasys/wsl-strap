# Just Example. Rewrite below:

# Add:
#Start-Process -verb runas -FilePath netsh.exe -ArgumentList "interface portproxy add v4tov4 listenport=25565 connectaddress=192.168.55.70"

# Delete;
#Start-Process -verb runas -FilePath netsh.exe -ArgumentList "interface portproxy del v4tov4 listenport=25565 connectaddress=192.168.55.70"

# Example (Add SSH):
#Start-Process -verb runas -FilePath netsh.exe -ArgumentList "interface portproxy add v4tov4 listenport=22 connectaddress=192.168.55.70"
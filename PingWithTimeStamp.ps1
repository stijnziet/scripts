# Easy time stamp ping script
# ditiswat.stijnziet.nl
# 22 january 2024

$ipaddress = Read-Host "Enter IP or Hostname"
ping.exe -t $ipaddress | foreach {"{0} - {1}" -f (Get-Date), $_}

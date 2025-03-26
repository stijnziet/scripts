Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
$ConfirmPreference = 'None'
Install-PackageProvider -Name NuGet -Force
Install-Module -Name PSWindowsUpdate -Force
Import-Module PSWindowsUpdate -Force
Get-WindowsUpdate -AcceptAll -Install

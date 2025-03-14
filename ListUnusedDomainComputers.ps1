#List domain computers not seen for a year
#Script by ditiswat.stijnziet.nl
#9 jan 2024

# Import the Active Directory module
Import-Module ActiveDirectory


$computers = Get-ADComputer -Filter {Enabled -eq $true -and Name -like "VLBES-PC*"} -Properties LastLogonDate | Where-Object {$_.LastLogonDate -lt (Get-Date).AddDays(-365)} | Sort-Object -Property LastLogonDate

foreach ($computer in $computers) {
    Write-Output "Computer Name: $($computer.Name)"
    Write-Output "Last Logon Date: $($computer.LastLogonDate)"
    Write-Output "--------------------------"
}
echo Done
pause

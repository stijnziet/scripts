#Force log off disconnected users on server. Run from AD.
#Script by ditiswat.stijnziet.nl
#26 july 2023

Start-Transcript C:\autologoff.log
$count = 0
$group = "<Usergroup>"

#Als er meerdere groepen zijn met dezelfde naam:
#$OUpath = 'ou=<OU>,dc=<domain>,dc=local'
#$group = Get-ADGroup -Filter * -SearchBase $OUpath | Where-Object {$_.Name -eq "<Usergroup>"}

$users = Get-ADGroupMember -Identity $group | Select-Object -ExpandProperty SamAccountName

Write-Host $users
foreach ($user in $users) 
{
    $sessions = quser /server:<servernaam> | findstr /R /C:"$user" | findstr /R /C:"Disc" 

    Write-Host "------------------"
    Write-Host "testing" $user
    Write-Host "session" $sessions
    if ($null -ne $sessions) 
    {
        $sessionId = ($sessions -split ' +')[2]
        Write-Host "Logging off" $user "with id" $sessionId
        logoff $sessionId /server:OBI-TS22
        $count = $count + 1
    
    }
    else
    {
        Write-Host $user "not disconnected, skipping..."
    }
}
Write-Host "=========================="
Write-Host "Users logged off:" $count
Stop-Transcript

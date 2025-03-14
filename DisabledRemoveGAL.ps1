#Remove all disabled users from GAL
#Script by ditiswat.stijnziet.nl
#9 aug 2023


Start-Transcript c:\tmp\GAL.log
$users = Get-ADUser -Filter { Enabled -eq $false }
foreach ($user in $users) 
{
    $name = $user.Name
    $DN = $user.DistinguishedName
            
    #check status. Empty = false
    $property = Get-ADUser -Identity $DN -Properties msExchHideFromAddressLists | Select-Object msExchHideFromAddressLists
    Write-Host $name pre-HideGAL: $property

    #write new value
    Set-ADUser -Identity $DN -Replace @{msExchHideFromAddressLists = $true }
            
    #check status again
    $property = Get-ADUser -Identity $DN -Properties msExchHideFromAddressLists | Select-Object msExchHideFromAddressLists
    Write-Host $name post-HideGAL: $property
    Write-Host "--------------------------"
}
Stop-Transcript

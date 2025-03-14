# Automaticallay disable expired accounts and move to specific OU
# by ditiswat.stijnziet.nl
# 29-10-2024

$targetOU = "OU=TargetOU,OU=ParentOU,DC=example,DC=com"
$logFilePath = "C:\path\to\scripts\logfile.txt"

# Get expired accounts in Active Directory
$expiredAccounts = Get-ADUser -Filter { AccountExpirationDate -lt (Get-Date) -and Enabled -eq $true } -Properties AccountExpirationDate

foreach ($account in $expiredAccounts)
{
    # Disable the user account
    Disable-ADAccount -Identity $account.DistinguishedName
    
    # Move the user account to the target OU
    Move-ADObject -Identity $account.DistinguishedName -TargetPath $targetOU
    
    $logMessage = "User $($account.SamAccountName) has been disabled and moved to $targetOU"
    Write-Output $logMessage
    Add-Content -Path $logFilePath -Value $logMessage
}

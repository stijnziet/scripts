#Automated process of matching UPN's with AD/Azure sync
#Script by ditiswat.stijnziet.nl
#WARNING! UNTESTED!
#2 nov 2023

# Connect to Exchange Server
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://<ExchangeServerFQDN>/PowerShell/ -Authentication Kerberos
Import-PSSession $Session -AllowClobber -DisableNameChecking

# Get all shared mailboxes
$SharedMailboxes = Get-Mailbox -RecipientTypeDetails SharedMailbox

# Loop through each shared mailbox and enable MessageCopyForSentAs
foreach ($Mailbox in $SharedMailboxes)
{
    Set-Mailbox -Identity $Mailbox.Identity -MessageCopyForSentAsEnabled $true
}

# Disconnect from Exchange Server
Remove-PSSession $Session

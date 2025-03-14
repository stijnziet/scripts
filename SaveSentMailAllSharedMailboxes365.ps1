#Enable sent message saved in shared mailbox for all shared mailboxes
#Script by ditiswat.stijnziet.nl
#2 nov 2023

# Connect to Exchange Online
Connect-ExchangeOnline

# Get all shared mailboxes
$mailboxes = Get-Mailbox -RecipientTypeDetails SharedMailbox

# Set the MessageCopyForSentAsEnabled property to true for each shared mailbox
foreach ($mailbox in $mailboxes)
{
    Set-Mailbox -Identity $mailbox.Identity -MessageCopyForSentAsEnabled $true
    Write-Host "Set to true for mailbox: $($mailbox.Name)"
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline

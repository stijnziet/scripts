#Automated process of matching UPN's with AD/Azure sync
#Script by ditiswat.stijnziet.nl
#src: https://www.steijvers.com/2021/05/27/error-type-attributevaluemustbeunique/
#1 aug 2023

Write-Host "UPN AD/AAD sync 0.1"
Write-host "---------------"
Write-Host "Login to 365"
Install-Module MSOnline
Import-Module MSOnline
Connect-MsolService

function UPNsync
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$naam
    )
    $guid = get-aduser -Identity $naam | Select-Object -ExpandProperty ObjectGuid
    $upn = get-aduser -Identity $naam | Select-Object -ExpandProperty UserPrincipalName
    Write-Host "continue with:" $upn 
    Pause
    Write-Host "Guid:" $guid
    $base64 = "" 
    #$guid = "815fbd36-983d-4304-82fc-370f4691c354"
    $base64 = [system.convert]::ToBase64String(([GUID]$guid).ToByteArray())
    Write-Host "Basse64:" $base64
    Write-host "---------------"

    #365 gedeelte
    Set-MsolUser -UserPrincipalName $upn -ImmutableId $base64
    Write-Host "Done"
    Write-host "---------------"
    Write-Host "Typ UPNsync -naam <voornaam> <achternaam>"
    Write-host "---------------"
}
Write-Host "Script loaded..."
Write-Host "Typ UPNsync -naam <voornaam> <achternaam>"
Write-host "---------------"

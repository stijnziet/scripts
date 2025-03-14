#Search for items in all GPO's
#Script by ditiswat.stijnziet.nl
#3 nov 2021

$String = "Zoekterm"
$Domain = "jouwdomein.local"

$NearestDC = (Get-ADDomainController -Discover -NextClosestSite).Name

#Get a list of GPOs from the domain
$GPOs = Get-GPO -All -Domain $Domain -Server $NearestDC | sort DisplayName

#Go through each Object and check its XML against $String
Foreach ($GPO in $GPOs)
{
  
  Write-Host "Zoeken in $($GPO.DisplayName)"
  
  #Get Current GPO Report (XML)
  $CurrentGPOReport = Get-GPOReport -Guid $GPO.Id -ReportType Xml -Domain $Domain -Server $NearestDC
  
  If ($CurrentGPOReport -match $String)
  {
    Write-Host "A Group Policy matching ""$($String)"" has been found:" -ForegroundColor Green
    Write-Host "-  GPO Name: $($GPO.DisplayName)" -ForegroundColor Green
    Write-Host "-  GPO Id: $($GPO.Id)" -ForegroundColor Green
    Write-Host "-  GPO Status: $($GPO.GpoStatus)" -ForegroundColor Green
  }
  
}

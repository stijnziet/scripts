#ditiswat.stijnziet.nl
#22-01-25
#search uninstall commands for software

# Define a function
$search = "??"
function Get-RegistryKeys
{
    # Array to store found registry keys
    $RegistryKeys = @()

    # Search 64-bit registry for installed software
    $RegistryKeys += Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" `
        -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName -like "*$search*" }

    # Search 32-bit registry for installed software
    $RegistryKeys += Get-ItemProperty -Path "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" `
        -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName -like "*$search*" }

    # Output results
    if ($RegistryKeys)
    {
        foreach ($key in $RegistryKeys)
        {
            Write-Host "Software Name: $($key.DisplayName)" -ForegroundColor Yellow
            Write-Host "Publisher: $($key.Publisher)" -ForegroundColor Cyan
            Write-Host "Registry Key Location: $($key.PSPath)" -ForegroundColor Green
            Write-Host "Uninstall String: $($key.UninstallString)" -ForegroundColor White
            Write-Host "----------------------------------------------------"
        }
    }
    else
    {
        Write-Host "No software found with the name ''." -ForegroundColor Red
    }
}

# Call the function
Get-RegistryKeys

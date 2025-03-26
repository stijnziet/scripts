#List all local admins on a computer and export the results to an Excel file
#Script by ditiswat.stijnziet.nl
#26-3-2025

# Define paths
$LocalTagPath = "C:\ProgramData\Powershell\ladmin-checked.tag"
$PublicExcelPath = "\\ServerName\public\ladmin_checked.xlsx"

if (Test-Path $LocalTagPath)
{
    exit
}

# Ensure the ImportExcel module is installed
if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
    Install-Module -Name ImportExcel -Force -Scope CurrentUser
}

# Get the current logged-in user
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()

# Get all members of the local administrators group
$adminGroupMembers = Get-LocalGroupMember -Group "Administrators"
$adminUsernamesList = $adminGroupMembers | ForEach-Object { $_.Name }
$adminUsernames = $adminUsernamesList -join "`n"  # Use `n` for new lines in Excel cells

# Check if the current user is a member of the local administrators group
$isAdmin = $adminUsernamesList -contains $currentUser.Name

# Prepare data for export
$currentDate = Get-Date -Format "yyyy-MM-dd"
$computerName = $env:COMPUTERNAME
$userName = $currentUser.Name
$localAdminStatus = if ($isAdmin) { "Yes" } else { "No" }

$output = [PSCustomObject]@{
    "Date"                = $currentDate
    "Computer Name"       = $computerName
    "User Name"           = $userName
    "Local Admin"         = $localAdminStatus
    "Admin Group Members" = $adminUsernames
}

# Export the results to an Excel file and append new entries
$output | Export-Excel -Path $PublicExcelPath -AutoSize -WorksheetName "LocalAdmins" -Append

# Enable text wrapping for the "Admin Group Members" column
$excelPackage = Open-ExcelPackage -Path $PublicExcelPath
$worksheet = $excelPackage.Workbook.Worksheets["LocalAdmins"]
$columnIndex = ($worksheet.Dimension.End.Column) # Assuming "Admin Group Members" is the last column
$worksheet.Column($columnIndex).Style.WrapText = $true
Close-ExcelPackage $excelPackage

# Create the tag file to indicate the script has run successfully
New-Item -Path $LocalTagPath -ItemType File -Force
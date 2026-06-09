# Install Deleted basic store apps
# by ditiswat@stijnziet
# 20260609

$ErrorActionPreference = "Stop"

function Test-IsElevated {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal(
        [Security.Principal.WindowsIdentity]::GetCurrent()
    )

    return $currentPrincipal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}

function Register-ExistingApp {
    param(
        [Parameter(Mandatory)]
        [string]$PackageName
    )

    $packages = Get-AppxPackage -Name $PackageName -ErrorAction SilentlyContinue

    foreach ($package in $packages) {
        $manifest = Join-Path $package.InstallLocation "AppxManifest.xml"

        if (Test-Path $manifest) {
            Write-Host "Registering $($package.Name)..."
            Add-AppxPackage -DisableDevelopmentMode -Register $manifest
        }
    }
}

function Install-StoreApp {
    param(
        [Parameter(Mandatory)]
        [string]$Id,

        [Parameter(Mandatory)]
        [string]$Name
    )

    Write-Host "Installing $Name..."

    winget install `
        --id $Id `
        --source msstore `
        --accept-package-agreements `
        --accept-source-agreements `
        --disable-interactivity
}

if (Test-IsElevated) {
    throw "Do not run this script elevated. Close PowerShell and run it normally as the affected user."
}

Write-Host "Running as user: $env:USERNAME"

Register-ExistingApp "Microsoft.DesktopAppInstaller"
Register-ExistingApp "Microsoft.WindowsNotepad"
Register-ExistingApp "Microsoft.WindowsCalculator"
Register-ExistingApp "Microsoft.Paint"
Register-ExistingApp "Microsoft.Windows.Photos"
Register-ExistingApp "Microsoft.ScreenSketch"
Register-ExistingApp "Microsoft.WindowsCamera"
Register-ExistingApp "Microsoft.WindowsSoundRecorder"
Register-ExistingApp "Microsoft.WindowsTerminal"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget/App Installer not found. Installing App Installer..."

    $wingetBundle = Join-Path $env:TEMP "Microsoft.DesktopAppInstaller.msixbundle"

    Invoke-WebRequest `
        -Uri "https://aka.ms/getwinget" `
        -OutFile $wingetBundle

    Add-AppxPackage -Path $wingetBundle

    $env:Path = [Environment]::GetEnvironmentVariable("Path", "User") + ";" + [Environment]::GetEnvironmentVariable("Path", "Machine")
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget is still unavailable. Sign out and back in, then run this script again."
}

Install-StoreApp -Id "9NBLGGH4NNS1" -Name "App Installer"
Install-StoreApp -Id "9MSMLRH6LZF3" -Name "Notepad"
Install-StoreApp -Id "9WZDNCRFHVN5" -Name "Calculator"
Install-StoreApp -Id "9PCFS5B6T72H" -Name "Paint"
Install-StoreApp -Id "9WZDNCRFJBH4" -Name "Microsoft Photos"
Install-StoreApp -Id "9MZ95KL8MR0L" -Name "Snipping Tool"
Install-StoreApp -Id "9WZDNCRFJBBG" -Name "Windows Camera"
Install-StoreApp -Id "9WZDNCRFHWKN" -Name "Voice Recorder"
Install-StoreApp -Id "9N0DX20HK701" -Name "Windows Terminal"

Write-Host "Done."

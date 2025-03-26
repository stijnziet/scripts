# Kill all services and processes related to Veeam Backup & Replication
# ditiswat.stijnziet.nl 
# 20-03-2025

# Stop all services starting with "Veeam"
Get-Service | Where-Object { $_.DisplayName -like "Veeam*" -and $_.Status -eq "Running" } | ForEach-Object {
    Write-Host "Stopping service: $($_.DisplayName)" -ForegroundColor Yellow
    Stop-Service -Name $_.Name -Force
    Write-Host "Service stopped: $($_.DisplayName)" -ForegroundColor Green
}
# Kill the process "Veeam.Backup.Shell" if it is running
Get-Process -Name "Veeam.Backup.Shell" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "Killing process: $($_.Name)" -ForegroundColor Yellow
    Stop-Process -Id $_.Id -Force
    Write-Host "Process killed: $($_.Name)" -ForegroundColor Green
}
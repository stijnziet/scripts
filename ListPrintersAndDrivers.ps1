# Lists every installed printer driver and *all* printers that use each driver
# Script by ditiswat.stijnziet.nl
# 2 june 2025

# Collect printer drivers
$printerDrivers = Get-CimInstance -ClassName Win32_PrinterDriver |
Select-Object Name, Manufacturer, DriverVersion, InfName

# Collect installed printers
$printers = Get-CimInstance -ClassName Win32_Printer |
Select-Object Name, DriverName

# Build report
$report = foreach ($drv in $printerDrivers)
{
    # Base driver name (strip any version/platform suffix)
    $baseName = ($drv.Name -split ',')[0].Trim()

    # Printers whose DriverName matches the base driver name
    $using = $printers | Where-Object { $_.DriverName -eq $baseName }

    [PSCustomObject]@{
        Driver       = $baseName
        Manufacturer = $drv.Manufacturer
        Version      = $drv.DriverVersion
        INF          = $drv.InfName
        Printers     = if ($using) { $using.Name -join "`n" } else { '-' }
    }
}

# Display without truncation
$report | Format-Table -Wrap -AutoSize

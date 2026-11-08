# System-Info.ps1
# Read-only system inventory

$ReportFolder = "$env:USERPROFILE\Desktop\PowerShell-Helpdesk-Toolkit\Reports"

New-Item -ItemType Directory -Force -Path $ReportFolder | Out-Null

$Computer = Get-CimInstance Win32_ComputerSystem
$OS = Get-CimInstance Win32_OperatingSystem
$Disk = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

$Report = [PSCustomObject]@{
    ComputerName = $Computer.Name
    UserName     = $Computer.UserName
    Domain       = $Computer.Domain
    Manufacturer = $Computer.Manufacturer
    Model        = $Computer.Model
    Windows      = $OS.Caption
    Version      = $OS.Version
    LastBoot     = $OS.LastBootUpTime
    RAM_GB       = [math]::Round($Computer.TotalPhysicalMemory / 1GB, 2)
}

$Report | Format-List

$Report | Export-Csv `
    -Path "$ReportFolder\System-Info.csv" `
    -NoTypeInformation `
    -Encoding UTF8

"`nDisk information:"
$Disk | Select-Object DeviceID,
    @{Name="SizeGB";Expression={[math]::Round($_.Size / 1GB,2)}},
    @{Name="FreeGB";Expression={[math]::Round($_.FreeSpace / 1GB,2)}} |
    Format-Table -AutoSize

Write-Host "Report saved to $ReportFolder\System-Info.csv"
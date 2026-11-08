# Helpdesk-Diagnostic.ps1
# Run basic read-only diagnostics on the local computer

$ReportFolder = "$env:USERPROFILE\Desktop\PowerShell-Helpdesk-Toolkit\Reports"

New-Item -ItemType Directory -Force -Path $ReportFolder | Out-Null

$ReportFile = Join-Path $ReportFolder (
    "Helpdesk-Report-{0:yyyyMMdd-HHmmss}.txt" -f (Get-Date)
)

Start-Transcript -Path $ReportFile -Force

try {
    Write-Host "`n===== SYSTEM INFORMATION =====" -ForegroundColor Cyan
    Get-CimInstance Win32_ComputerSystem |
        Select-Object Name, Domain, UserName, Manufacturer, Model |
        Format-List

    Write-Host "`n===== IP CONFIGURATION =====" -ForegroundColor Cyan
    Get-NetIPConfiguration |
        Format-List InterfaceAlias, IPv4Address, DNSServer, IPv4DefaultGateway

    Write-Host "`n===== DNS TEST =====" -ForegroundColor Cyan
    Resolve-DnsName DC01 -ErrorAction Continue

    Write-Host "`n===== DOMAIN CONTROLLER TEST =====" -ForegroundColor Cyan
    & nltest /dsgetdc:company.local

    Write-Host "`n===== SMB PORT TEST =====" -ForegroundColor Cyan
    Test-NetConnection DC01 -Port 445

    Write-Host "`n===== RECENT SYSTEM ERRORS =====" -ForegroundColor Cyan
    Get-WinEvent -FilterHashtable @{
        LogName   = "System"
        Level     = 2
        StartTime = (Get-Date).AddHours(-24)
    } -MaxEvents 10 -ErrorAction SilentlyContinue |
        Select-Object TimeCreated, Id, ProviderName, Message |
        Format-List
}
finally {
    Stop-Transcript
}

Write-Host "`nReport saved to: $ReportFile" -ForegroundColor Green
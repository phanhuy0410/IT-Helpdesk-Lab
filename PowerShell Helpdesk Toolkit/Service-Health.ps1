# Service-Health.ps1
# Read-only service health check

$ReportFolder = "C:\PowerShell-Helpdesk-Toolkit\Reports"
New-Item -ItemType Directory -Force -Path $ReportFolder | Out-Null

$ServiceNames = @(
    "DNS",
    "NTDS",
    "Netlogon",
    "LanmanServer",
    "DFSR"
)

$Results = foreach ($Name in $ServiceNames) {
    $Service = Get-Service -Name $Name -ErrorAction SilentlyContinue

    if ($Service) {
        [PSCustomObject]@{
            Computer = $env:COMPUTERNAME
            Service  = $Service.Name
            Display  = $Service.DisplayName
            Status   = $Service.Status
            Startup  = (Get-CimInstance Win32_Service `
                -Filter "Name='$Name'").StartMode
        }
    }
    else {
        [PSCustomObject]@{
            Computer = $env:COMPUTERNAME
            Service  = $Name
            Display  = "Not found"
            Status   = "NOT FOUND"
            Startup  = "N/A"
        }
    }
}

$Results | Format-Table -AutoSize

$Results | Export-Csv `
    -Path "$ReportFolder\Service-Health.csv" `
    -NoTypeInformation `
    -Encoding UTF8

Write-Host "Report saved to $ReportFolder\Service-Health.csv"
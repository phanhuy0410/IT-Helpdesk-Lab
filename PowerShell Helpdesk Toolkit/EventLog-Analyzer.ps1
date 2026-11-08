# EventLog-Analyzer.ps1
# Read-only System event log analyzer

param(
    [int]$Hours = 24
)

if ($Hours -lt 1 -or $Hours -gt 720) {
    throw "Hours must be between 1 and 720."
}

if ($env:COMPUTERNAME -eq "DC01") {
    $ReportFolder = "C:\PowerShell-Helpdesk-Toolkit\Reports"
}
else {
    $ReportFolder = "$env:USERPROFILE\Desktop\PowerShell-Helpdesk-Toolkit\Reports"
}

New-Item -ItemType Directory -Force -Path $ReportFolder | Out-Null

$StartTime = (Get-Date).AddHours(-$Hours)

$Events = Get-WinEvent -FilterHashtable @{
    LogName   = "System"
    Level     = 2, 3
    StartTime = $StartTime
} -ErrorAction SilentlyContinue

$Report = foreach ($Event in $Events) {
    [PSCustomObject]@{
        Computer    = $env:COMPUTERNAME
        TimeCreated = $Event.TimeCreated
        EventID     = $Event.Id
        Level       = $Event.LevelDisplayName
        Source      = $Event.ProviderName
        Message     = $Event.Message
    }
}

$Report |
    Sort-Object TimeCreated -Descending |
    Export-Csv "$ReportFolder\EventLog-Analyzer.csv" `
        -NoTypeInformation -Encoding UTF8

$Report |
    Select-Object -First 20 TimeCreated, EventID, Level, Source |
    Format-Table -AutoSize

Write-Host "Events exported to $ReportFolder\EventLog-Analyzer.csv"
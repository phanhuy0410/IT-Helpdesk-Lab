# Network-Diagnostics.ps1
# Read-only network troubleshooting

$ReportFolder = "$env:USERPROFILE\Desktop\PowerShell-Helpdesk-Toolkit\Reports"
New-Item -ItemType Directory -Force -Path $ReportFolder | Out-Null

$DC = "DC01"
$Domain = "company.local"
$Share = "\\DC01\HR"

$Results = @()

function Add-Result {
    param(
        [string]$Check,
        [string]$Status,
        [string]$Details
    )

    $script:Results += [PSCustomObject]@{
        Time    = Get-Date
        Check   = $Check
        Status  = $Status
        Details = $Details
    }
}

# 1. IP configuration
$IP = Get-NetIPConfiguration |
    Where-Object { $_.IPv4DefaultGateway -or $_.IPv4Address } |
    Select-Object -First 1

if ($IP) {
    Add-Result "IP Configuration" "INFO" `
        "Interface=$($IP.InterfaceAlias); IPv4=$($IP.IPv4Address.IPAddress); DNS=$($IP.DNSServer.ServerAddresses -join ', ')"
}
else {
    Add-Result "IP Configuration" "FAIL" "No IPv4 configuration found"
}

# 2. DNS resolution
try {
    $DNSResult = Resolve-DnsName $DC -ErrorAction Stop
    Add-Result "DNS DC01" "PASS" ($DNSResult.IPAddress -join ", ")
}
catch {
    Add-Result "DNS DC01" "FAIL" $_.Exception.Message
}

try {
    $DomainDNS = Resolve-DnsName $Domain -ErrorAction Stop
    Add-Result "DNS Domain" "PASS" "Domain name resolved"
}
catch {
    Add-Result "DNS Domain" "FAIL" $_.Exception.Message
}

# 3. Domain Controller discovery
$DCDiscovery = & nltest /dsgetdc:$Domain 2>&1
if ($LASTEXITCODE -eq 0) {
    Add-Result "Domain Controller Discovery" "PASS" ($DCDiscovery -join " ")
}
else {
    Add-Result "Domain Controller Discovery" "FAIL" ($DCDiscovery -join " ")
}

# 4. Ping DC01
$Ping = Test-Connection -ComputerName $DC -Count 2 -Quiet
if ($Ping) {
    Add-Result "Ping DC01" "PASS" "ICMP response received"
}
else {
    Add-Result "Ping DC01" "WARNING" "No ICMP response; firewall may block ping"
}

# 5. SMB port 445
$SMB = Test-NetConnection -ComputerName $DC -Port 445 -WarningAction SilentlyContinue
if ($SMB.TcpTestSucceeded) {
    Add-Result "SMB TCP 445" "PASS" "Port 445 is reachable"
}
else {
    Add-Result "SMB TCP 445" "FAIL" "Cannot connect to TCP 445"
}

# 6. File share access
try {
    Get-ChildItem -Path $Share -ErrorAction Stop | Out-Null
    Add-Result "HR Share Access" "PASS" "Successfully accessed $Share"
}
catch {
    Add-Result "HR Share Access" "FAIL" $_.Exception.Message
}

# Display and export
$Results | Format-Table -Wrap -AutoSize

$Results | Export-Csv `
    -Path "$ReportFolder\Network-Diagnostics.csv" `
    -NoTypeInformation `
    -Encoding UTF8

Write-Host "`nReport saved to $ReportFolder\Network-Diagnostics.csv"
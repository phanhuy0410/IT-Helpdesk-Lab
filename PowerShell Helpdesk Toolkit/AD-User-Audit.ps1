# AD-User-Audit.ps1
# Read-only Active Directory user audit

Import-Module ActiveDirectory -ErrorAction Stop

$ReportFolder = "C:\PowerShell-Helpdesk-Toolkit\Reports"
New-Item -ItemType Directory -Force -Path $ReportFolder | Out-Null

$SearchBase = "OU=Company,DC=company,DC=local"

$Users = Get-ADUser `
    -Filter * `
    -SearchBase $SearchBase `
    -Properties Enabled, LockedOut, LastLogonDate, PasswordLastSet

$Report = foreach ($User in $Users) {
    [PSCustomObject]@{
        Username       = $User.SamAccountName
        DisplayName    = $User.Name
        Enabled        = $User.Enabled
        LockedOut      = $User.LockedOut
        LastLogonDate  = $User.LastLogonDate
        PasswordLastSet = $User.PasswordLastSet
    }
}

$Report | Sort-Object Username | Format-Table -AutoSize

$Report | Export-Csv `
    "$ReportFolder\AD-User-Audit.csv" `
    -NoTypeInformation `
    -Encoding UTF8

Write-Host "AD audit saved to $ReportFolder\AD-User-Audit.csv"
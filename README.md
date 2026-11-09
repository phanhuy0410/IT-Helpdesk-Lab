# IT Support Home Lab

## 1. Project Overview

This project involves building a simulated small-business IT environment using VMware Workstation, Windows Server 2022, and Windows 10.

The main objective is to gain hands-on experience with common IT Support and Helpdesk tasks, including user account management, access control, network configuration, troubleshooting, and system diagnostics automation using PowerShell.

## 2. Lab Environment

| Virtual Machine | Operating System | Role | Internal IP |
|---|---|---|---|
| DC01 | Windows Server 2022 | Domain Controller, DNS, File Server, RRAS | 192.168.100.10 |
| CLIENT01 | Windows 11 | Domain-joined client workstation | 192.168.100.20 |

**Network Configuration:**
- Domain: `company.local`
- VMware VMnet1: Host-only network for internal communication.
- VMware VMnet8: NAT network providing Internet access to DC01.
- DC01 uses RRAS NAT to share its Internet connection with CLIENT01.
- CLIENT01 uses DC01 as its DNS server and default gateway.

## 3. Hands-on Labs

### 3.1. Active Directory
- Installed and configured Active Directory Domain Services (AD DS).
- Created the `company.local` domain.
- Created and managed user accounts, security groups, and Organizational Units (OUs).
- Joined a Windows 11 workstation to the domain.
- Verified domain authentication using domain user accounts.

### 3.2. File Sharing and NTFS Permissions
- Created shared folders for different departments.
- Configured SMB sharing and NTFS permissions.
- Managed folder access through security groups.
- Tested access permissions using different user accounts.
- Troubleshot file-sharing access issues.

### 3.3. DNS and Network Troubleshooting
- Configured DNS Server and DNS Forwarders.
- Tested name resolution using `nslookup` and `Resolve-DnsName`.
- Verified IP configuration, default gateway, and network connectivity.
- Troubleshot DNS configuration issues on the client workstation.

### 3.4. Group Policy (GPO)
- Created and managed Group Policy Objects (GPOs).
- Configured User Configuration policies.
- Restricted access to Control Panel through Group Policy.
- Troubleshot GPO issues related to OU linking and security filtering.
- Used `gpupdate` and `gpresult` to verify and troubleshoot policy application.

### 3.5. Windows Event Viewer
- Reviewed System and Application logs.
- Analyzed Error and Warning events.
- Used Event IDs and event details to support troubleshooting.

### 3.6. PowerShell Helpdesk Toolkit

Developed PowerShell scripts to automate basic system checks and collect diagnostic information.

| Script | Description |
|---|---|
| `System-Info.ps1` | Collects computer, operating system, RAM, and disk information. |
| `Network-Diagnostics.ps1` | Checks IP configuration, DNS, network connectivity, and SMB access. |
| `Service-Health.ps1` | Checks the status of Windows services. |
| `EventLog-Analyzer.ps1` | Collects Error and Warning events from Windows Event Logs. |
| `AD-User-Audit.ps1` | Audits Active Directory user account status. |
| `Helpdesk-Diagnostic.ps1` | Combines system diagnostic checks into a single report. |

Diagnostic reports are exported in CSV format for easier review and record keeping.

## 4. Tools and Technologies

- VMware Workstation
- Windows Server 2022
- Windows 10
- Active Directory Domain Services (AD DS)
- DNS Server
- Group Policy Management
- SMB File Sharing
- NTFS Permissions
- Routing and Remote Access Service (RRAS) / NAT
- Windows Event Viewer
- Windows PowerShell

## 5. Key Outcomes

- Managing user accounts and access permissions in a Windows domain environment.
- Configuring and troubleshooting DNS and internal network connectivity.
- Managing shared folder access and NTFS permissions.
- Configuring and troubleshooting Group Policy.
- Analyzing Windows Event Logs for troubleshooting.
- Developing PowerShell scripts to automate basic system diagnostics.

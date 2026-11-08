# IT Helpdesk Home Lab

## 1. Giới thiệu dự án

Dự án xây dựng môi trường IT Helpdesk mô phỏng hệ thống mạng doanh nghiệp nhỏ bằng VMware Workstation, Windows Server 2022 và Windows 11.

Mục tiêu là thực hành các công việc cơ bản của nhân viên IT Support / Helpdesk như quản lý tài khoản người dùng, phân quyền truy cập, cấu hình mạng, xử lý sự cố và tự động hóa kiểm tra hệ thống bằng PowerShell.

## 2. Mô hình hệ thống

| Máy ảo | Hệ điều hành | Chức năng | IP nội bộ |
|---|---|---|---|
| DC01 | Windows Server 2022 | Domain Controller, DNS, File Server, RRAS | 192.168.100.10 |
| CLIENT01 | Windows 11 | Máy tính người dùng, tham gia Domain | 192.168.100.20 |

**Thông tin mạng:**
- Domain: `company.local`
- VMware VMnet1: Host-only – mạng nội bộ.
- VMware VMnet8: NAT – kết nối Internet cho DC01.
- DC01 sử dụng RRAS NAT để chia sẻ kết nối Internet cho CLIENT01.
- CLIENT01 sử dụng DC01 làm DNS Server và Default Gateway.

## 3. Nội dung thực hành

### 3.1. Active Directory
- Cài đặt và cấu hình Active Directory Domain Services.
- Tạo Domain `company.local`.
- Tạo và quản lý User, Group, Organizational Unit (OU).
- Join máy Windows 11 vào Domain.
- Kiểm tra đăng nhập bằng tài khoản Domain.

### 3.2. File Sharing và NTFS Permissions
- Tạo thư mục chia sẻ theo phòng ban.
- Cấu hình SMB Sharing và NTFS Permissions.
- Phân quyền truy cập thông qua Security Group.
- Kiểm tra quyền truy cập bằng các tài khoản khác nhau.
- Xử lý sự cố không truy cập được thư mục chia sẻ.

### 3.3. DNS và Network Troubleshooting
- Cấu hình DNS Server và DNS Forwarder.
- Kiểm tra phân giải tên miền bằng `nslookup` và `Resolve-DnsName`.
- Kiểm tra IP, Gateway và kết nối mạng.
- Xử lý sự cố cấu hình DNS trên máy Client.

### 3.4. Group Policy (GPO)
- Tạo và quản lý Group Policy Object.
- Cấu hình User Configuration.
- Thực hành giới hạn quyền truy cập Control Panel.
- Kiểm tra OU Linking và Security Filtering.
- Sử dụng `gpupdate` và `gpresult` để xử lý lỗi GPO.

### 3.5. Windows Event Viewer
- Kiểm tra System và Application Logs.
- Phân tích các sự kiện Error và Warning.
- Sử dụng Event ID và thông tin sự kiện để hỗ trợ troubleshooting.

### 3.6. PowerShell Helpdesk Toolkit

Xây dựng các script PowerShell hỗ trợ kiểm tra và thu thập thông tin hệ thống.

| Script | Chức năng |
|---|---|
| `System-Info.ps1` | Thu thập thông tin máy tính, hệ điều hành, RAM và ổ đĩa. |
| `Network-Diagnostics.ps1` | Kiểm tra IP, DNS, kết nối mạng và SMB. |
| `Service-Health.ps1` | Kiểm tra trạng thái các Windows Services. |
| `EventLog-Analyzer.ps1` | Thu thập các sự kiện Error và Warning. |
| `AD-User-Audit.ps1` | Kiểm tra trạng thái tài khoản Active Directory. |
| `Helpdesk-Diagnostic.ps1` | Tổng hợp thông tin chẩn đoán hệ thống. |

Các báo cáo được xuất ra định dạng CSV hoặc TXT để thuận tiện cho việc kiểm tra và lưu trữ.

## 4. Công cụ và công nghệ

- VMware Workstation
- Windows Server 2022
- Windows 11
- Active Directory Domain Services
- DNS Server
- Group Policy Management
- SMB File Sharing
- NTFS Permissions
- RRAS NAT
- Windows Event Viewer
- Windows PowerShell

## 5. Kết quả đạt được

Thông qua dự án, tôi đã thực hành:

- Quản lý tài khoản và phân quyền trong môi trường Domain.
- Cấu hình và xử lý sự cố DNS, mạng nội bộ.
- Quản lý quyền truy cập thư mục chia sẻ.
- Cấu hình và troubleshooting Group Policy.
- Phân tích Windows Event Logs.
- Viết PowerShell script hỗ trợ chẩn đoán hệ thống.

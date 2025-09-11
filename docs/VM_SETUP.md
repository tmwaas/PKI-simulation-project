# VM Setup (Proxmox / VirtualBox)

Recommended VM specs:
- Root CA & Ansible control: 2 vCPU, 4 GB RAM, 20 GB disk (RHEL 8/9)
- Linux client: 1 vCPU, 2 GB RAM, 10 GB disk (RHEL 8/9)
- Windows client: 2 vCPU, 4 GB RAM, 40 GB disk (Windows Server 2022)
- Nagios server: 1 vCPU, 2 GB RAM, 20 GB disk (RHEL 8/9)
- GitLab: container or VM depending on resources

Networking:
- Use a private bridged network with subnet `10.0.0.0/24`.
- Assign IPs statically or use DHCP reservations:
  - VM1 Root CA: 10.0.0.10
  - VM2 Linux client: 10.0.0.11
  - VM3 Windows client: 10.0.0.12
  - VM4 Nagios: 10.0.0.13

Basic OS update (RHEL):
```
sudo dnf update -y
sudo dnf install -y openssl python3 python3-pip git
```

For Windows Server:
- Run Windows Update and install PowerShell features for WinRM.
- Enable WinRM and configure an account for Ansible connection (or use Negotiate/Kerberos).

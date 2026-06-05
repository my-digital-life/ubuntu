# Jellyfin on Ubuntu Server 24.04.4 LTS with Windows SMB Share

A complete walkthrough for installing Jellyfin on Ubuntu Server 24.04.4 LTS and connecting it to a Windows SMB share for TV shows.

---

## System Specifications

### Virtual Machine

- Ubuntu Server 24.04.4 LTS
- 2 vCPUs
- 4 GB RAM

### Media Storage

Media files are stored on a Windows SMB share:

\\192.168.1.14\tv

Windows Username:

Scott

---

## Step 1 - Update Ubuntu

Update all packages and reboot.

```bash
sudo apt update
sudo apt full-upgrade -y
sudo reboot
```

Verify the operating system:

```bash
lsb_release -a
```

Expected output:

```text
Distributor ID: Ubuntu
Description: Ubuntu 24.04.4 LTS
Codename: noble
```

---

## Step 2 - Install Required Packages

Install common utilities and SMB support.

```bash
sudo apt install -y \
curl \
wget \
nano \
cifs-utils \
smbclient \
ufw \
apt-transport-https \
gnupg \
htop
```

### Package Overview

| Package | Purpose |
|----------|----------|
| curl | Download files and repository keys |
| wget | Download files |
| nano | Text editor |
| cifs-utils | Mount SMB shares |
| smbclient | Test SMB connectivity |
| ufw | Firewall management |
| apt-transport-https | HTTPS repository support |
| gnupg | Repository key management |
| htop | Resource monitoring |

---

## Step 3 - Configure Firewall

Allow SSH:

```bash
sudo ufw allow OpenSSH
```

Allow Jellyfin:

```bash
sudo ufw allow 8096/tcp
```

Enable the firewall:

```bash
sudo ufw enable
```

Check firewall status:

```bash
sudo ufw status
```

---

## Step 4 - Add the Jellyfin Repository

Import the Jellyfin signing key:

```bash
curl -fsSL https://repo.jellyfin.org/jellyfin_team.gpg.key | \
sudo gpg --dearmor -o /usr/share/keyrings/jellyfin.gpg
```

Create the repository file:

```bash
echo "deb [signed-by=/usr/share/keyrings/jellyfin.gpg] https://repo.jellyfin.org/ubuntu noble main" | \
sudo tee /etc/apt/sources.list.d/jellyfin.list
```

Update package information:

```bash
sudo apt update
```

---

## Step 5 - Install Jellyfin

Install Jellyfin:

```bash
sudo apt install jellyfin -y
```

Verify the service:

```bash
systemctl status jellyfin
```

Enable startup at boot:

```bash
sudo systemctl enable jellyfin
```

---

## Step 6 - Access Jellyfin

Find the server IP address:

```bash
hostname -I
```

Open a browser and navigate to:

```text
http://SERVER-IP:8096
```

Example:

```text
http://192.168.1.155:8096
```

Complete the initial setup wizard.

---

## Step 7 - Create the SMB Mount Point

Create the mount directory:

```bash
sudo mkdir -p /mnt/tv
```

---

## Step 8 - Create SMB Credentials File

Create the credentials file:

```bash
sudo nano /root/tv.creds
```

Contents:

```text
username=windos username
password=YOUR_WINDOWS_PASSWORD
```

Secure the credentials file:

```bashs
sudo chmod 600 /root/tv.creds
```

---

## Step 9 - Test SMB Connectivity

Verify the share is reachable:

```bash
smbclient -L //192.168.1.14 -U Scott
```

---

## Step 10 - Mount the Share

Mount the share:

```bash
sudo mount -t cifs //192.168.1.14/tv /mnt/tv \
-o credentials=/root/tv.creds,vers=3.0
```

Verify:

```bash
ls /mnt/tv
```

You should see your TV show folders.

---

## Step 11 - Give Jellyfin Access

Unmount the share:

```bash
sudo umount /mnt/tv
```

Remount using Jellyfin ownership:

```bash
sudo mount -t cifs //192.168.1.14/tv /mnt/tv \
-o credentials=/root/tv.creds,uid=jellyfin,gid=jellyfin,iocharset=utf8,vers=3.0
```

Verify Jellyfin can access the files:

```bash
sudo -u jellyfin ls /mnt/tv
```

---

## Step 12 - Configure Automatic Mounting

Edit fstab:

```bash
sudo nano /etc/fstab
```

Add:

```fstab
//192.168.1.14/tv /mnt/tv cifs credentials=/root/tv.creds,uid=jellyfin,gid=jellyfin,iocharset=utf8,vers=3.0,_netdev,nofail 0 0
```

Test the configuration:

```bash
sudo umount /mnt/tv
sudo mount -a
```

Verify:

```bash
ls /mnt/tv
```

Reboot and confirm the share mounts automatically.

---

## Step 13 - Add the Library to Jellyfin

Open Jellyfin and:

1. Go to Dashboard
2. Select Libraries
3. Click Add Media Library
4. Choose TV Shows
5. Browse to:

```text
/mnt/tv
```

6. Save the library

---

## Verify Everything Works

Check mounted shares:

```bash
mount | grep tv
```

Check Jellyfin status:

```bash
systemctl status jellyfin
```

Check available media:

```bash
ls /mnt/tv
```

---

## Final Result

Windows SMB Share:

```text
\\192.168.1.14\tv
```

Mounted on Ubuntu:

```text
/mnt/tv
```

Served by Jellyfin:

```text
http://SERVER-IP:8096
```

The Jellyfin server will automatically mount the SMB share at boot and provide access to the TV library through the web interface, mobile apps, and compatible media clients.

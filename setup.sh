#!/bin/bash

# curl -sSL https://raw.githubusercontent.com/my-digital-life/ubuntu/refs/heads/main/setup.sh -o setup.sh && chmod +x setup.sh && ./setup.sh

# -------------------------------
# Update package lists
# -------------------------------
run_cmd "sudo apt update"

# -------------------------------
# Upgrade all packages to latest versions
# -------------------------------
run_cmd "sudo apt -y upgrade"

# -------------------------------
# Install SSH and OpenSSH server and More
# -------------------------------
run_cmd "sudo apt -y install ssh openssh-server open-vm-tools samba cifs-utils smbclient"

# -------------------------------
# Enable root login via SSH
# This modifies the sshd_config file to allow root login
# Change Workgroup name in /etc/ssh/sshd_config
# -------------------------------
run_cmd "sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config"

# run_cmd "sudo sed -i 's/workgroup = WORKGROUP/workgroup = TOKEN/' /etc/samba/smb.conf"

# -------------------------------
# Restart SSH service to apply changes
# -------------------------------
run_cmd "sudo systemctl restart ssh"

# samba reload restart
# run_cmd "sudo systemctl daemon-reload"
# run_cmd "sudo systemctl restart smbd nmbd"

# echo "[INFO] Setup complete. Check $LOG_FILE for any errors."

# Add new user
# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Create the user
USERNAME="user"
PASSWORD="user"

# Check if user already exists
if id "$USERNAME" &>/dev/null; then
  echo "User '$USERNAME' already exists."
else
  useradd -m "$USERNAME"
  echo "$USERNAME:$PASSWORD" | chpasswd
  echo "User '$USERNAME' created with password '$PASSWORD'."
fi

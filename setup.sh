#!/bin/bash
# https://raw.githubusercontent.com/my-digital-life/ubuntu/refs/heads/main/setup.sh
# curl -L -o setup.sh https://raw.githubusercontent.com/my-digital-life/ubuntu/refs/heads/main/setup.sh && sudo chmod +x setup.sh

# -------------------------------
# Update package lists
# -------------------------------
run_cmd "sudo apt update"

# -------------------------------
# Upgrade all packages to latest versions
# -------------------------------
run_cmd "sudo apt -y upgrade"

# -------------------------------
# Install SSH and OpenSSH server
# -------------------------------
run_cmd "sudo apt -y install ssh openssh-server open-vm-tools samba cifs-utils smbclient"

# -------------------------------
# Enable root login via SSH
# This modifies the sshd_config file to allow root login
# -------------------------------
run_cmd "sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config"

# -------------------------------
# Restart SSH service to apply changes
# -------------------------------
run_cmd "sudo systemctl restart ssh"

echo "[INFO] Setup complete. Run ./setup.sh"

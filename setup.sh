#!/bin/bash

# Define a log file for error reporting
LOG_FILE="/var/log/server_setup.log"

# Function to log errors
log_error() {
    echo "[ERROR] $1" | tee -a "$LOG_FILE"
}

# Function to run a command and log errors if it fails
run_cmd() {
    echo "[INFO] Running: $1"
    eval "$1"
    if [ $? -ne 0 ]; then
        log_error "Command failed: $1"
    fi
}

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

run_cmd "sudo sed -i 's/workgroup = WORKGROUP/workgroup = TOKEN/' /etc/ssh/sshd_config"

# -------------------------------
# Restart SSH service to apply changes
# -------------------------------
run_cmd "sudo systemctl restart ssh"

echo "[INFO] Setup complete. Check $LOG_FILE for any errors."

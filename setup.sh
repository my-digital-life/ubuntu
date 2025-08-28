#!/bin/bash

run_cmd "sudo timedatectl set-timezone America/Toronto"

# run_cmd "sudo apt update"

run_cmd "sudo apt -y dist-upgrade"

run_cmd "sudo apt -y install ssh openssh-server open-vm-tools samba cifs-utils smbclient"

run_cmd "sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config"

run_cmd "sudo sed -i 's/workgroup = WORKGROUP/workgroup = TOKEN/' /etc/ssh/sshd_config"
run_cmd "sudo apt install samba"
run_cmd "sudo mkdir /media/share"
run_cmd "sudo chmod -R 0777 /media/share/"
run_cmd "sudo systemctl daemon-reload"
run_cmd "sudo systemctl restart smbd nmbd"


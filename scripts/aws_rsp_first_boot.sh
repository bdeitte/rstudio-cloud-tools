#!/bin/bash
exec 1> /var/log/first-boot.log 2>&1
set -ex

# Default user and password: We use Instance ID as initial password
RSP_USERNAME=rstudio-user
RSP_PASSWORD=`curl -s http://169.254.169.254/latest/meta-data/instance-id`

# Create rstudio-team group
groupadd rstudio-team
GROUP_ID=$(cut -d: -f3 < <(getent group rstudio-team))

# Create user
adduser --disabled-password --gecos "" --gid $GROUP_ID $RSP_USERNAME

# Set password
echo "$RSP_USERNAME:$RSP_PASSWORD" | chpasswd

# Add default user to sudoers with no password
echo "$RSP_USERNAME ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

# Enable and start services
systemctl enable rstudio-server
systemctl enable rstudio-launcher
systemctl start rstudio-server
systemctl start rstudio-launcher

/usr/local/bin/wait-for-it.sh localhost:80 -t 0

# Clean up
sed -i '/\/usr\/local\/bin\/rsp_first_boot.sh/d' /etc/crontab
rm /usr/local/bin/rsp_first_boot.sh

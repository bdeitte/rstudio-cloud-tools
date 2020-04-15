#!/bin/bash
set -ex


# Disable service
# First boot script will create the default user, start and enable the services
systemctl daemon-reload
systemctl disable rstudio-connect

# Setup first boot
mv /tmp/rsc_first_boot.sh /usr/local/bin/rsc_first_boot.sh && chmod +x /usr/local/bin/rsc_first_boot.sh
echo '@reboot root /usr/local/bin/rsc_first_boot.sh' >> /etc/crontab

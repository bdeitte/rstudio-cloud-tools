#!/bin/bash
set -ex


# Disable service
# First boot script will create the default user, start and enable the services
systemctl daemon-reload
systemctl disable rstudio-server
systemctl disable rstudio-launcher

# Setup first boot script
mv /tmp/rsp_first_boot.sh /usr/local/bin/rsp_first_boot.sh && chmod +x /usr/local/bin/rsp_first_boot.sh
echo '@reboot root /usr/local/bin/rsp_first_boot.sh' >> /etc/crontab

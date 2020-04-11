#!/bin/bash
set -ex


# Disable service
# First boot script start and enable the services
systemctl daemon-reload
systemctl disable rstudio-pm

# Setup first boot
mv /tmp/rspm_first_boot.sh /usr/local/bin/rspm_first_boot.sh && chmod +x /usr/local/bin/rspm_first_boot.sh
echo '@reboot root /usr/local/bin/rspm_first_boot.sh' >> /etc/crontab


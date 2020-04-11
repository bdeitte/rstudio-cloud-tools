#!/bin/bash
exec 1> /var/log/first-boot.log 2>&1
set -ex

# Default user and password: We use Instance ID as initial password
RSC_USERNAME=admin
RSC_PASSWORD=`curl -s http://169.254.169.254/latest/meta-data/instance-id`

# Enable and start services
systemctl enable rstudio-connect
systemctl start rstudio-connect

/usr/local/bin/wait-for-it.sh localhost:80 -t 0

# Create admin user
curl -i -X POST -d "{\"email\": \"rstudio@example.com\", \"username\": \"${RSC_USERNAME}\", \"password\": \"${RSC_PASSWORD}\"}" localhost:80/__api__/v1/users

# Clean up
sed -i '/\/usr\/local\/bin\/rsc_first_boot.sh/d' /etc/crontab
rm /usr/local/bin/rsc_first_boot.sh

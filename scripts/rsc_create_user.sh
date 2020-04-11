#!/bin/bash
set -ex


RSP_USERNAME=${RSP_USERNAME:-rstudio-admin}
RSP_PASSWORD=${RSP_PASSWORD:-rstudio}

# Enable and start services
systemctl enable rstudio-connect
systemctl start rstudio-connect

/usr/local/bin/wait-for-it.sh localhost:80 -t 0

# Create admin user
curl -i -X POST -d "{\"email\": \"rstudio@example.com\", \"username\": \"${RSC_USERNAME}\", \"password\": \"${RSC_PASSWORD}\"}" localhost:80/__api__/v1/users

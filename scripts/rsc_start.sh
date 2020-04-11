#!/bin/bash
set -ex


# Enable and start services
systemctl enable rstudio-connect
systemctl start rstudio-connect
/usr/local/bin/wait-for-it.sh localhost:80 -t 60

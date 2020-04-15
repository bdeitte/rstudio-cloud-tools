#!/bin/bash
set -ex


# Enable and start services
systemctl enable rstudio-server
systemctl enable rstudio-launcher
systemctl start rstudio-server
systemctl start rstudio-launcher
systemctl restart rstudio-server
systemctl restart rstudio-launcher
/usr/local/bin/wait-for-it.sh localhost:80 -t 60

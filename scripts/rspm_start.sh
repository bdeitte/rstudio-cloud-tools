#!/bin/bash
set -ex


# Enable and start services
systemctl enable rstudio-pm
systemctl start rstudio-pm
systemctl restart rstudio-pm
/usr/local/bin/wait-for-it.sh localhost:80 -t 60

# We bounce and call to the license-manager for trial license to work
/opt/rstudio-pm/bin/license-manager status
systemctl restart rstudio-pm
/usr/local/bin/wait-for-it.sh localhost:80 -t 60
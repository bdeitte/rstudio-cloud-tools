#!/bin/bash

set -xe

export DEBIAN_FRONTEND=noninteractive

RSPM_VERSION=${RSPM_VERSION:-1.1.2-10}
R_VERSION=${R_VERSION:-"3.6.3"}


# Config RSPM -----------------------------------------------------------------

cat >/etc/rstudio-pm/rstudio-pm.gcfg <<EOL
; RStudio Package Manager configuration file

[Server]
; Address = RSPM_SERVER_ADDRESS
RVersion = /opt/R/${R_VERSION}

[HTTP]
; RStudio Package Manager will listen on this network address for HTTP connections.
Listen = :80

[Database]
Provider = sqlite
EOL

# Allow privileged ports
setcap 'cap_net_bind_service=+ep' /opt/rstudio-pm/bin/rstudio-pm


# Defaults --------------------------------------------------------------------

# Enable and start services
systemctl enable rstudio-pm
systemctl start rstudio-pm
bash ./wait-for-it.sh localhost:80 -t 60

# We bounce and call to the license-manager for trial license to work
/opt/rstudio-pm/bin/license-manager status
systemctl restart rstudio-pm.service
bash ./wait-for-it.sh localhost:80 -t 60

# Create cran repo
/opt/rstudio-pm/bin/rspm create repo --name=cran --description='Access CRAN packages'
/opt/rstudio-pm/bin/rspm subscribe --repo=cran --source=cran
/opt/rstudio-pm/bin/rspm sync --wait
echo "Listing..."
/opt/rstudio-pm/bin/rspm list


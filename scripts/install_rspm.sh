#!/bin/bash

set -xe

export DEBIAN_FRONTEND=noninteractive

RSPM_VERSION=${RSPM_VERSION:-1.1.2-10}

# Install RSPM
apt-get update
apt-get install -y gdebi-core
curl -o /tmp/rstudio-pm_${RSPM_VERSION}_amd64.deb https://s3.amazonaws.com/rstudio-package-manager/ubuntu/amd64/rstudio-pm_${RSPM_VERSION}_amd64.deb
gdebi --non-interactive /tmp/rstudio-pm_${RSPM_VERSION}_amd64.deb
rm /tmp/rstudio-pm_${RSPM_VERSION}_amd64.deb

# Configure RSPM
cat >/etc/rstudio-pm/rstudio-pm.gcfg <<EOL
; RStudio Package Manager configuration file

[Server]
; Address = RSPM_SERVER_ADDRESS
RVersion = /opt/R/3.6.3

[HTTP]
; RStudio Package Manager will listen on this network address for HTTP connections.
Listen = :80

[Database]
Provider = sqlite
EOL

# Allow privileged ports
setcap 'cap_net_bind_service=+ep' /opt/rstudio-pm/bin/rstudio-pm

# Restart service
systemctl restart rstudio-pm

bash ./wait-for-it.sh localhost:80 -t 60

# Create CRAN repo
/opt/rstudio-pm/bin/rspm create repo --name=cran --description='Access CRAN packages'
/opt/rstudio-pm/bin/rspm subscribe --repo=cran --source=cran
/opt/rstudio-pm/bin/rspm sync --wait
echo "Listing repos:"
/opt/rstudio-pm/bin/rspm list
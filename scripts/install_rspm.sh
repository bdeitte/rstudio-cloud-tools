#!/bin/bash
set -xe

export DEBIAN_FRONTEND=noninteractive

RSPM_VERSION=${RSPM_VERSION:-1.1.4-3}

# Install RSPM
apt-get update
apt-get install -y gdebi-core
curl -o /tmp/rstudio-pm_${RSPM_VERSION}_amd64.deb https://s3.amazonaws.com/rstudio-package-manager/ubuntu/amd64/rstudio-pm_${RSPM_VERSION}_amd64.deb
RSTUDIO_INSTALL_NO_LICENSE_INITIALIZATION=1 gdebi --non-interactive /tmp/rstudio-pm_${RSPM_VERSION}_amd64.deb
rm /tmp/rstudio-pm_${RSPM_VERSION}_amd64.deb

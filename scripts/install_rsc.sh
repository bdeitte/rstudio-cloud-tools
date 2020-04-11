#!/bin/bash
set -xe

export DEBIAN_FRONTEND=noninteractive

RSC_VERSION=${RSC_VERSION:-1.8.0.4-21}

# Install RSC
apt-get update
apt-get install -y gdebi-core
curl -o /tmp/rstudio-connect_${RSC_VERSION}_amd64.deb https://s3.amazonaws.com/rstudio-connect/rstudio-connect_${RSC_VERSION}_amd64.deb
RSTUDIO_INSTALL_NO_LICENSE_INITIALIZATION=1 gdebi --non-interactive /tmp/rstudio-connect_${RSC_VERSION}_amd64.deb
rm /tmp/rstudio-connect_${RSC_VERSION}_amd64.deb

#!/bin/bash
set -xe

export DEBIAN_FRONTEND=noninteractive

RSP_VERSION=${RSP_VERSION:-1.2.5033-1}

apt-get update
apt-get install -y gdebi-core
curl -o /tmp/rstudio-server-pro-${RSP_VERSION}-amd64.deb https://download2.rstudio.org/server/trusty/amd64/rstudio-server-pro-${RSP_VERSION}-amd64.deb
RSTUDIO_INSTALL_NO_LICENSE_INITIALIZATION=1 gdebi --non-interactive /tmp/rstudio-server-pro-${RSP_VERSION}-amd64.deb
rm /tmp/rstudio-server-pro-${RSP_VERSION}-amd64.deb

# We disable and stop the service until 1.3 that uses RSTUDIO_INSTALL_NO_LICENSE_INITIALIZATION=1
systemctl disable rstudio-server
systemctl disable rstudio-launcher
systemctl stop rstudio-server
systemctl stop rstudio-launcher
#!/bin/bash
set -xe

export DEBIAN_FRONTEND=noninteractive

RSP_VERSION=${RSP_VERSION:-1.3.959}

apt-get update
apt-get install -y gdebi-core
curl -o /tmp/rstudio-server-pro-${RSP_VERSION}-amd64.deb https://download2.rstudio.org/server/bionic/amd64/rstudio-server-pro-1.3.959-1-amd64.deb
RSTUDIO_INSTALL_NO_LICENSE_INITIALIZATION=1 gdebi --non-interactive /tmp/rstudio-server-pro-${RSP_VERSION}-amd64.deb
rm /tmp/rstudio-server-pro-${RSP_VERSION}-amd64.deb

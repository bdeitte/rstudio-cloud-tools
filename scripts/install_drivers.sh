#!/bin/bash

set -xe

export DEBIAN_FRONTEND=noninteractive

DRIVERS_VERSION=${DRIVERS_VERSION:-1.6.1}

apt-get update -y
apt-get install -y unixodbc unixodbc-dev gdebi libaio1

# Download and install
curl -o /tmp/rstudio-drivers_${DRIVERS_VERSION}_amd64.deb https://drivers.rstudio.org/7C152C12/installer/rstudio-drivers_${DRIVERS_VERSION}_amd64.deb
gdebi --non-interactive /tmp/rstudio-drivers_${DRIVERS_VERSION}_amd64.deb
rm /tmp/rstudio-drivers_${DRIVERS_VERSION}_amd64.deb

# Append odbcinst.ini
cat /opt/rstudio-drivers/odbcinst.ini.sample | sudo tee /etc/odbcinst.ini

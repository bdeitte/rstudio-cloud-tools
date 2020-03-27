#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

set -xe

export RSC_VERSION=$1
export USERNAME=$2
export PASSWORD=$3
export R_VERSION=$4
export PYTHON_VERSION=$5
export ANACONDA_VERSION=$6
export DRIVERS_VERSION=$7

R_VERSION=$R_VERSION bash ./install_r.sh
PYTHON_VERSION=$PYTHON_VERSION ANACONDA_VERSION=$ANACONDA_VERSION bash ./install_python.sh
DRIVERS_VERSION=$DRIVERS_VERSION bash ./install_drivers.sh
RSC_VERSION=$RSC_VERSION PASSWORD=$PASSWORD bash ./install_rsc.sh

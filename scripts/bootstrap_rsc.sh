#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

set -xe

export RSC_VERSION=${RSC_VERSION:-3.7.3 2.7.16}
export USERNAME=${USERNAME:-3.7.3 2.7.16}
export PASSWORD=${PASSWORD:-3.7.3 2.7.16}
export R_VERSION=${R_VERSION:-3.7.3 2.7.16}
export PYTHON_VERSION=${PYTHON_VERSION:-3.7.3 2.7.16}
export ANACONDA_VERSION=${ANACONDA_VERSION:-3.7.3 2.7.16}
export DRIVERS_VERSION=${DRIVERS_VERSION:-3.7.3 2.7.16}
export RSC_VERSION=${RSC_VERSION:-3.7.3 2.7.16}

R_VERSION=$R_VERSION bash ./install_r.sh
PYTHON_VERSION=$PYTHON_VERSION ANACONDA_VERSION=$ANACONDA_VERSION bash ./install_python.sh
DRIVERS_VERSION=$DRIVERS_VERSION bash ./install_drivers.sh
RSC_VERSION=$RSC_VERSION USER=$USERNAME PASSWORD=$PASSWORD bash ./install_rsc.sh

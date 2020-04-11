#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
set -xe

export RSC_VERSION=${RSC_VERSION:-1.8.2-10}
export RSC_USERNAME=${RSC_USERNAME:-admin}
export RSC_PASSWORD=${RSC_PASSWORD:-rstudio}
export R_VERSIONS=${R_VERSIONS:-3.6.3}
export PYTHON_VERSIONS=${PYTHON_VERSIONS:-3.7.3}
export ANACONDA_VERSIONS=${ANACONDA_VERSIONS:-Miniconda3-4.7.10}
export DRIVERS_VERSION=${DRIVERS_VERSION:-1.6.1}
export RSPM_ADDRESS=${RSPM_ADDRESS}


# Utility scripts
mv ./wait-for-it.sh /usr/local/bin/wait-for-it.sh
chmod +x /usr/local/bin/wait-for-it.sh

# Install
bash ./install_r.sh
bash ./install_python.sh
bash ./install_drivers.sh
bash ./install_rsc.sh
bash ./config_rsc.sh
bash ./rsc_create_user.sh

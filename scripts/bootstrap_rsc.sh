#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

set -xe

export RSC_VERSION=${RSC_VERSION:-1.8.2-10}
export RSC_USERNAME=${RSC_USERNAME:-admin}
export RSC_PASSWORD=${RSC_PASSWORD:-rstudio}
export R_VERSION=${R_VERSION:-3.6.3 3.5.3}
export PYTHON_VERSION=${PYTHON_VERSION:-3.7.3 2.7.16}
export ANACONDA_VERSION=${ANACONDA_VERSION:-Miniconda3-4.7.10 Miniconda2-4.7.12}
export DRIVERS_VERSION=${DRIVERS_VERSION:-2.6.1}
export RSPM_URL=${RSPM_URL}

bash ./install_r.sh
bash ./install_python.sh
bash ./install_drivers.sh
bash ./install_rsc.sh

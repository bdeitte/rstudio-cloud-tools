#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

set -xe

export RSP_VERSION=${RSC_VERSION:-1.2.5033-1}
export RSP_USERNAME=${RSC_USERNAME:-rstudio}
export RSP_PASSWORD=${RSC_PASSWORD:-rstudio}
export R_VERSION=${R_VERSION:-3.6.3 3.5.3}
export PYTHON_VERSION=${PYTHON_VERSION:-3.7.3 2.7.16}
export ANACONDA_VERSION=${ANACONDA_VERSION:-Miniconda3-4.7.10 Miniconda2-4.7.12}
export DRIVERS_VERSION=${DRIVERS_VERSION:-1.6.1}
export RSPM_ADDRESS=${RSPM_ADDRESS}
export RSC_ADDRESS=${RSC_ADDRESS}

bash ./install_r.sh
bash ./install_python.sh
bash ./install_drivers.sh
bash ./install_jupyter.sh
bash ./install_rsp.sh

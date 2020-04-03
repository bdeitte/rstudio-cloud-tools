#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

set -xe

export RSC_VERSION=${RSC_VERSION:-3.7.3 2.7.16}
export RSC_USERNAME=${RSC_USERNAME:-3.7.3 2.7.16}
export RSC_PASSWORD=${RSC_PASSWORD:-3.7.3 2.7.16}
export R_VERSION=${R_VERSION:-3.7.3 2.7.16}
export PYTHON_VERSION=${PYTHON_VERSION:-3.7.3 2.7.16}
export ANACONDA_VERSION=${ANACONDA_VERSION:-3.7.3 2.7.16}
export DRIVERS_VERSION=${DRIVERS_VERSION:-3.7.3 2.7.16}
export RSPM_URL=${RSPM_URL:-3.7.3 2.7.16}

bash ./install_r.sh
bash ./install_python.sh
bash ./install_drivers.sh
bash ./install_rsc.sh

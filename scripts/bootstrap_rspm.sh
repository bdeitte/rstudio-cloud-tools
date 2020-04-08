#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

set -xe

export RSPM_VERSION=${RSPM_VERSION:-1.1.2-10}
export R_VERSION=${R_VERSION:-3.6.3}

bash ./install_r.sh
bash ./install_rspm.sh

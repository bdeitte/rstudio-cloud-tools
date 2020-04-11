#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
set -xe

export RSPM_VERSION=${RSPM_VERSION:-1.1.2-10}
export R_VERSION=${R_VERSION:-3.6.3}


# Utility scripts
mv ./wait-for-it.sh /usr/local/bin/wait-for-it.sh
chmod +x /usr/local/bin/wait-for-it.sh


# Install
bash ./install_r.sh
R_VERSIONS=${R_VERSION} bash ./install_rspm.sh

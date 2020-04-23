#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
set -xe

export RSPM_VERSION=${RSPM_VERSION:-1.1.4-3}
export RSPM_DATA_DIR=${RSPM_DATA_DIR:-/mnt/rstudio-pm}
export MNT_USER=${MNT_USER:-rstudio-pm}
export MNT_GROUP=${MNT_GROUP:-rstudio-pm}
export R_VERSION=${R_VERSION:-3.6.3}


# Utility scripts
mv ./wait-for-it.sh /usr/local/bin/wait-for-it.sh
chmod +x /usr/local/bin/wait-for-it.sh

# Install
bash ./install_r.sh
bash ./install_rspm.sh
DISK_MNT=${RSPM_DATA_DIR} MNT_USER=${MNT_USER} MNT_GROUP=${MNT_GROUP} bash ./az_data_disk.sh
R_VERSIONS=${R_VERSION} bash ./config_rspm.sh
bash ./rspm_start.sh
bash ./rspm_create_repo.sh

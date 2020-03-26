#!/bin/bash

set -xe

exec > >(tee /var/log/bootstrap.log | logger -t bootstrap -s 2>/dev/console) 2>&1

export RSPM_VERSION=$1
export R_VERSION=$2

R_VERSION=$R_VERSION bash ./install_r.sh
RSPM_VERSION=$RSPM_VERSION bash ./install_rspm.sh

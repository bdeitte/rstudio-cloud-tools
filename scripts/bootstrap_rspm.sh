#!/bin/bash

set -xe

export RSPM_VERSION=$1
export R_VERSION=$2

R_VERSION=$R_VERSION bash ./install_r.sh
RSPM_VERSION=$RSPM_VERSION bash ./install_rspm.sh

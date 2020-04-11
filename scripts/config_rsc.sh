#!/bin/bash
set -ex

export DEBIAN_FRONTEND=noninteractive

R_VERSIONS=${R_VERSIONS:-"3.6.3,3.5.3"}
PYTHON_VERSIONS=${PYTHON_VERSIONS:-"3.7.3,2.7.16"}
TF_VERSION=${TF_VERSION:-1.15.0}

# Internal
R_VERS=($(echo "$R_VERSIONS" | tr ',' '\n'))
PY_VERS=($(echo "$PYTHON_VERSIONS" | tr ',' '\n'))


# Tensorflow C lib ------------------------------------------------------------
# From https://www.tensorflow.org/install/lang_c
curl -o /usr/local/src/libtensorflow.tar.gz https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-{$TF_VERSION}.tar.gz -o /usr/local/src/libtensorflow.tar.gz
mkdir -p /usr/local/tensorflow
tar -C /usr/local/tensorflow -xzf /usr/local/src/libtensorflow.tar.gz

mkdir -p /etc/systemd/system/rstudio-connect.service.d

cat << 'EOF' > /etc/systemd/system/rstudio-connect.service.d/env.conf
[Service]
Environment="LIBRARY_PATH=/usr/local/tensorflow/lib"
Environment="LD_LIBRARY_PATH=/usr/local/tensorflow/lib"
EOF


# Config RSC ------------------------------------------------------------------

RSC_CONFIG_FILE=/etc/rstudio-connect/rstudio-connect.gcfg

cat >$RSC_CONFIG_FILE <<EOL
; RStudio Connect configuration file

; Address is a public URL for this RStudio Connect server. Must be configured
; to enable features like including links to your content in emails. If
; Connect is deployed behind an HTTP proxy, this should be the URL for Connect
; in terms of that proxy.
;
; Address = https://rstudio-connect.company.com
;[Server]
;Address = RSC_SERVER_ADDRESS

[HTTP]
Listen = :80

[Authentication]
Provider = password

[Database]
Provider = sqlite

[Python]
Enabled = true
Executable = /opt/python/${PY_VERS[0]}/bin/python

;[RPackageRepository "CRAN"]
;URL = RSPM_SERVER_ADDRESS

;[RPackageRepository "RSPM"]
;URL = RSPM_SERVER_ADDRESS
EOL


# Other services --------------------------------------------------------------

if [[ ! -z "${RSPM_ADDRESS}" ]]; then
    sed -i -e 's|;\[RPackageRepository "CRAN"\]|\[RPackageRepository "CRAN"\]|' $RSC_CONFIG_FILE
    sed -i -e 's|;\[RPackageRepository "RSPM"\]|\[RPackageRepository "RSPM"\]|' $RSC_CONFIG_FILE
    sed -i -e "s|;URL = RSPM_SERVER_ADDRESS|URL = ${RSPM_ADDRESS}/cran/__linux__/bionic/latest|" $RSC_CONFIG_FILE
fi


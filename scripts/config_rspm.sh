#!/bin/bash
set -ex

export DEBIAN_FRONTEND=noninteractive

R_VERSIONS=${R_VERSIONS:-"3.6.3,3.5.3"}

# Internal
R_VERS=($(echo "$R_VERSIONS" | tr ',' '\n'))


# Config RSPM -----------------------------------------------------------------

RSPM_CONFIG_FILE=/etc/rstudio-pm/rstudio-pm.gcfg

cat >$RSPM_CONFIG_FILE <<EOL
; RStudio Package Manager configuration file

[Server]
;Address = RSPM_SERVER_ADDRESS
;DataDir = /mnt/rstudio-pm
RVersion = /opt/R/${R_VERS[0]}

[HTTP]
; RStudio Package Manager will listen on this network address for HTTP connections.
Listen = :80

[Database]
Provider = sqlite
EOL

if [[ ! -z "${RSPM_DATA_DIR}" ]]; then
    sed -i -e "s|;DataDir = /mnt/rstudio-pm|DataDir = ${RSPM_DATA_DIR}|" $RSPM_CONFIG_FILE
fi

# Allow privileged ports
setcap 'cap_net_bind_service=+ep' /opt/rstudio-pm/bin/rstudio-pm

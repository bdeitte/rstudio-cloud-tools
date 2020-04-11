#!/bin/bash
set -ex

export DEBIAN_FRONTEND=noninteractive

R_VERSIONS=${R_VERSIONS:-"3.6.3,3.5.3"}
PYTHON_VERSIONS=${PYTHON_VERSION:-"3.7.3,2.7.16"}

# Internal
R_VERS=($(echo "$R_VERSIONS" | tr ',' '\n'))
PY_VERS=($(echo "$PYTHON_VERSIONS" | tr ',' '\n'))


# R ---------------------------------------------------------------------------
# add_cran_apt_source
# install_apt_packages /tmp/bionic_r_packages.txt

install_r_packages() {
    # given a one-per-line file of R packages, parses the file and installs those R
    # packages to the provided (or default) R installation.

    # passing a r binary as second arg will install with that R version
    local DEPS_FILE=${1}
    local R_BIN=${2:-"/usr/lib/R/bin/R"}

    # passing a CRAN repo as third arg will install from that repo
    local CRAN_REPO=${3:-"https://cran.rstudio.com"}

    # loop and create an R matrix-style string of packages
    local r_packages=""
    while read line; do
        # don't append empty lines
        if [ ! -z "$line" ]; then
          r_packages="${r_packages} \"${line}\","
        fi
    done < $DEPS_FILE

    # install packages enumerated in the file to the R binary passed
    $R_BIN --slave -e "install.packages(c(${r_packages%?}), repos = \"${CRAN_REPO}\")" > /dev/null
}

# For each R version
for ((i = 0; i < ${#R_VERS[@]}; ++i)); do
    # Install dependencies
    install_r_packages /tmp/r_packages.txt "/opt/R/${R_VERS[i]}/bin/R" "http://demo.rstudiopm.com/all/__linux__/bionic/latest"

    # Disable Repos HTTP warning
    cat << EOF >> /opt/R/${R_VERS[i]}/lib/R/etc/Renviron.site
RSTUDIO_DISABLE_SECURE_DOWNLOAD_WARNING=1
EOF
done


# Python ----------------------------------------------------------------------

# Kernels: Remove default "jupyter" kernel, don't show this environment as a kernel
/opt/python/jupyter/bin/jupyter kernelspec remove python3 -f

# For each Python version
for ((i = 0; i < ${#PY_VERS[@]}; ++i)); do
    # Install Python dependencies
    if (( "${PY_VERS[i]:0:1}" == "3" )); then
        /opt/python/${PY_VERS[i]}/bin/pip install -r /tmp/python_packages.txt
    fi
    
    # Kernels: Make Python installation available
    /opt/python/${PY_VERS[i]}/bin/pip install ipykernel
    /opt/python/${PY_VERS[i]}/bin/python -m ipykernel install --name python"${PY_VERS[i]:0:1}" --display-name "Python ${PY_VERS[i]}"
done

# Configure jupyter extensions
/opt/python/jupyter/bin/jupyter-nbextension install --sys-prefix --py rsp_jupyter
/opt/python/jupyter/bin/jupyter-nbextension enable --sys-prefix --py rsp_jupyter
/opt/python/jupyter/bin/jupyter-nbextension install --sys-prefix --py rsconnect_jupyter
/opt/python/jupyter/bin/jupyter-nbextension enable --sys-prefix --py rsconnect_jupyter
/opt/python/jupyter/bin/jupyter-serverextension enable --sys-prefix --py rsconnect_jupyter


# Config RSP and Launcher -----------------------------------------------------

# Set global R and python version
cat >/etc/profile.d/rstudio.sh <<EOL
export SHELL=/bin/bash
export PATH=/opt/R/${R_VERS[0]}/bin:/opt/python/${PY_VERS[0]}/bin:$PATH
EOL


cat >/etc/rstudio/rserver.conf <<EOL
# Server Configuration File

www-port=80

server-project-sharing=0
server-health-check-enabled=1
admin-enabled=1
admin-group=rstudio-team

# Launcher Config
launcher-address=127.0.0.1
launcher-port=5559
launcher-sessions-enabled=1
launcher-default-cluster=Local
launcher-sessions-callback-address=http://127.0.0.1:80
EOL


cat >/etc/rstudio/launcher.conf <<EOL
[server]
address=127.0.0.1
port=5559
server-user=rstudio-server
admin-group=rstudio-server
authorization-enabled=1
thread-pool-size=4
enable-debug-logging=1

[cluster]
name=Local
type=Local
EOL


cat >/etc/rstudio/jupyter.conf <<EOL
jupyter-exe=/opt/python/jupyter/bin/jupyter
notebooks-enabled=1
labs-enabled=1

default-session-cluster=Local
EOL


cat >/etc/rstudio/rsession.conf <<EOL
#default-rsconnect-server=RSC_SERVER_ADDRESS
EOL


cat >/etc/rstudio/repos.conf <<EOL
#CRAN=RSPM_SERVER_ADDRESS
EOL


cat >/etc/rstudio/launcher-env <<EOL
JobType: any
Environment: PATH=/opt/R/${R_VERS[0]}/bin:/opt/python/${PY_VERS[0]}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
EOL


# Other Services --------------------------------------------------------------

REPOS_CONFIG_FILE=/etc/rstudio/repos.conf
RSESSION_CONFIG_FILE=/etc/rstudio/rsession.conf

if [[ ! -z "${RSC_ADDRESS}" ]]; then
    sed -i -e "s|#default-rsconnect-server=RSC_SERVER_ADDRESS|default-rsconnect-server=http://${RSC_ADDRESS}|" $RSESSION_CONFIG_FILE
fi

if [[ ! -z "${RSPM_ADDRESS}" ]]; then
    sed -i -e "s|#CRAN=RSPM_SERVER_ADDRESS|CRAN=http://${RSPM_ADDRESS}/cran/__linux__/bionic/latest|" $REPOS_CONFIG_FILE
fi

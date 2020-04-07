#!/bin/bash

set -xe

export DEBIAN_FRONTEND=noninteractive

export RSP_VERSION=${RSP_VERSION:-1.2.5033-1}
export RSP_USERNAME=${RSP_USERNAME:-rstudio}
export RSP_PASSWORD=${RSP_PASSWORD:-rstudio}

# Use the first version of R and Python on the list as the default ones
for MAIN_R_VER in ${R_VERSION}
do
    break;
done

for MAIN_PYTHON_VER in ${PYTHON_VERSION}
do
    break;
done

# Remove default "jupyter" kernel: don't show this environment as a kernel
/opt/python/jupyter/bin/jupyter kernelspec remove python3 -f
/opt/python/jupyter/bin/pip uninstall -y ipykernel


# Install and configure kernels
for PY_VER in ${PYTHON_VERSION}
do
    /opt/python/${PY_VER}/bin/pip install ipykernel
    /opt/python/${PY_VER}/bin/python -m ipykernel install --name python"${PY_VER:0:1}" --display-name "Python ${PY_VER[i]}"
done

# Install Python packages

cat >/tmp/requirements.txt <<EOL
altair
beautifulsoup4
cloudpickle
cython
dask
gensim
ipykernel
matplotlib
nltk
numpy
pandas
pillow
pyarrow
requests
scipy
scikit-image
scikit-learn
scrapy
seaborn
spacy
sqlalchemy
statsmodels
tensorflow==1.15.0
keras
xgboost
rsconnect_jupyter
EOL

/opt/python/${MAIN_PYTHON_VER}/bin/pip install -r /tmp/requirements.txt

# Install R packages

cat >/tmp/r_pkgs.txt <<EOL
tidyverse
rmarkdown
shiny
tidymodels
data.table
packrat
odbc
sparklyr
reticulate
rsconnect
devtools
RCurl
tensorflow
keras
EOL

install_r_packages() {
	# given a one-per-line file of R packages, parses the file and installs those R
	# packages to the provided (or default) R installation.

	set -xe

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

install_r_packages /tmp/r_pkgs.txt /opt/R/${MAIN_R_VER}/bin/R "http://demo.rstudiopm.com/all/__linux__/bionic/latest"


# Install RSP
apt-get update
apt-get install -y gdebi-core
curl -o /tmp/rstudio-server-pro-${RSP_VERSION}-amd64.deb https://download2.rstudio.org/server/trusty/amd64/rstudio-server-pro-${RSP_VERSION}-amd64.deb
gdebi --non-interactive /tmp/rstudio-server-pro-${RSP_VERSION}-amd64.deb
rm /tmp/rstudio-server-pro-${RSP_VERSION}-amd64.deb

# Set global R and python version
cat >/etc/profile.d/rstudio.sh <<EOL
export SHELL=/bin/bash
export PATH=/opt/R/${MAIN_R_VER}/bin:/opt/python/${MAIN_PYTHON_VER}/bin:$PATH
EOL

# Config RSP and Launcher -----------------------------------------------------

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
Environment: PATH=/opt/R/${MAIN_R_VER}/bin:/opt/python/${MAIN_PYTHON_VER}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
EOL

# Create rstudio-team group
groupadd rstudio-team
GROUP_ID=$(cut -d: -f3 < <(getent group rstudio-team))
# Create admin user
adduser --disabled-password --gecos "" --gid $GROUP_ID $RSP_USERNAME
echo "$RSP_USERNAME:$RSP_PASSWORD" | chpasswd
# add default user to sudoers with no password
echo "$RSP_USERNAME ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

REPOS_CONFIG_FILE=/etc/rstudio/repos.conf
RSESSION_CONFIG_FILE=/etc/rstudio/rsession.conf

if [[ ! -z "${RSPM_ADDRESS}" ]]; then
	sed -i -e "s|#CRAN=RSPM_SERVER_ADDRESS|CRAN=http://${RSPM_ADDRESS}/cran/__linux__/bionic/latest|" $REPOS_CONFIG_FILE
fi

if [[ ! -z "${RSPM_ADDRESS}" ]]; then
	sed -i -e "s|#default-rsconnect-server=RSC_SERVER_ADDRESS|default-rsconnect-server=http://${RSC_ADDRESS}|" $RSESSION_CONFIG_FILE
fi

# enable and start services
systemctl enable rstudio-server
systemctl enable rstudio-launcher
systemctl restart rstudio-server
systemctl restart rstudio-launcher

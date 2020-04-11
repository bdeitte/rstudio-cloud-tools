#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
set -xe

export RSP_VERSION=${RSP_VERSION:-1.2.5033-1}
export RSP_USERNAME=${RSP_USERNAME:-rstudio-admin}
export RSP_PASSWORD=${RSP_PASSWORD:-rstudio}
export R_VERSION=${R_VERSION:-3.6.3}
export PYTHON_VERSION=${PYTHON_VERSION:-3.7.3}
export ANACONDA_VERSION=${ANACONDA_VERSION:-Miniconda3-4.7.10}
export DRIVERS_VERSION=${DRIVERS_VERSION:-1.6.1}
export RSPM_ADDRESS=${RSPM_ADDRESS}
export RSC_ADDRESS=${RSC_ADDRESS}


# Utility scripts
mv ./wait-for-it.sh /usr/local/bin/wait-for-it.sh
chmod +x /usr/local/bin/wait-for-it.sh


cat >/tmp/r_packages.txt <<EOL
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


cat >/tmp/python_packages.txt <<EOL
altair
beautifulsoup4
cloudpickle
cython
dash
dask
flask
gensim
ipykernel
matplotlib
nltk
numpy
pandas
pillow
plotly
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
tensorflow
keras
xgboost
rsconnect_jupyter
EOL


# Install
bash ./install_r.sh
bash ./install_python.sh
PREFIX_NAME=jupyter bash ./install_python.sh
bash ./install_drivers.sh
bash ./install_rsp.sh
R_VERSIONS=${R_VERSION} PYTHON_VERSIONS=${PYTHON_VERSION} bash ./config_rsp.sh
bash ./rsp_create_user.sh

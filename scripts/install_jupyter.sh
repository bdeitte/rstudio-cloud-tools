#!/bin/bash

set -xe

export PYTHON_VERSION=${PYTHON_VERSION:-3.7.3}
export ANACONDA_VERSION=${ANACONDA_VERSION:-Miniconda3-4.7.10}
export PREFIX_NAME=${PREFIX_NAME:-jupyter}
export URL_PATH=${URL_PATH:-miniconda}
export ANACONDA_REPO=${ANACONDA_REPO:-https://repo.anaconda.com}

# Use the first version of Python and Anaconda on the list for the Jupyter installation
for PY_VER in ${PYTHON_VERSION}
do
    break;
done

for ANA_VER in ${ANACONDA_VERSION}
do
    break;
done

# Install Python
mkdir -p /opt/python

echo "Installing Python version $PY_VER (Anaconda version $ANA_VER)"
curl -o /tmp/$ANA_VER-Linux-x86_64.sh $ANACONDA_REPO/$URL_PATH/$ANA_VER-Linux-x86_64.sh
bash /tmp/$ANA_VER-Linux-x86_64.sh -b -p /opt/python/$PY_VER
rm /tmp/$ANA_VER-Linux-x86_64.sh

echo "Verify Python $PY_VER"
/opt/python/$PY_VER/bin/python --version

echo "Install virtualenv Python $PY_VER"
/opt/python/$PY_VER/bin/pip install -U pip virtualenv==16.1.0

echo "Install Jupyter"
/opt/python/$PY_VER/bin/pip install -U jupyter jupyterlab rsp_jupyter rsconnect_jupyter

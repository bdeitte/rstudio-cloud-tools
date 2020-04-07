#!/bin/bash
set -xe

PYTHON_VERSION=${PYTHON_VERSION:-3.7.3}
ANACONDA_VERSION=${ANACONDA_VERSION:-Miniconda3-4.7.10}
PREFIX_NAME=${PREFIX_NAME:-$PYTHON_VERSION}
ANACONDA_REPO=${ANACONDA_REPO:-https://repo.anaconda.com}
URL_PATH=${URL_PATH:-miniconda}

mkdir -p /opt/python

echo "Installing Python version $PYTHON_VERSION (Anaconda version $ANACONDA_VERSION)"
curl -o /tmp/$ANACONDA_VERSION-Linux-x86_64.sh $ANACONDA_REPO/$URL_PATH/$ANACONDA_VERSION-Linux-x86_64.sh
bash /tmp/$ANACONDA_VERSION-Linux-x86_64.sh -b -p /opt/python/$PREFIX_NAME
rm /tmp/$ANACONDA_VERSION-Linux-x86_64.sh

echo "Verify Python $PREFIX_NAME"
/opt/python/$PREFIX_NAME/bin/python --version

echo "Install virtualenv Python $PREFIX_NAME"
/opt/python/$PREFIX_NAME/bin/pip install -U pip virtualenv==16.1.0

echo "Install Jupyter"
/opt/python/$PREFIX_NAME/bin/pip install -U jupyter jupyterlab rsp_jupyter rsconnect_jupyter ipykernel

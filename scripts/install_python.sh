#!/bin/bash
set -xe

ANACONDA_VERSION=${ANACONDA_VERSION:-Miniconda3-4.7.10}
PYTHON_VERSION=${PYTHON_VERSION:-3.7.3}
PREFIX_NAME=${PREFIX_NAME:-$PYTHON_VERSION}
ANACONDA_REPO=${ANACONDA_REPO:-https://repo.anaconda.com}
URL_PATH=${URL_PATH:-miniconda}


# Deps
apt-get update
apt-get install -y apt-transport-https python-pip libev-dev

# Install Anaconda
mkdir -p /opt/python
curl -o /tmp/$ANACONDA_VERSION-Linux-x86_64.sh $ANACONDA_REPO/$URL_PATH/$ANACONDA_VERSION-Linux-x86_64.sh
bash /tmp/$ANACONDA_VERSION-Linux-x86_64.sh -b -p /opt/python/$PREFIX_NAME
rm /tmp/$ANACONDA_VERSION-Linux-x86_64.sh

# Verify Python
/opt/python/$PREFIX_NAME/bin/python --version

# Install virtualenv
/opt/python/$PREFIX_NAME/bin/pip install -U pip==19.3.1 setuptools==46.1.3 virtualenv==16.7.10

#!/bin/bash

set -xe

export PYTHON_VERSION=${PYTHON_VERSION:-3.7.3 2.7.16}
export ANACONDA_VERSION=${ANACONDA_VERSION:-Miniconda3-4.7.10 Miniconda2-4.7.12}
export PREFIX_NAME=${PREFIX_NAME:-$PYTHON_VERSION}
export URL_PATH=${URL_PATH:-miniconda}
export REPO=${REPO:-https://repo.anaconda.com}

mkdir -p /opt/python

PY_VERS=($(echo $PYTHON_VERSION | tr " " "\n"))
ANA_VERS=($(echo $ANACONDA_VERSION | tr " " "\n"))

echo $PY_VERS

for index in ${!PY_VERS[*]}; do
    PY_VER=${PY_VERS[$index]}
    ANA_VER=${ANA_VERS[$index]}

    echo "Installing Python version ${PY_VER} - Anaconda version ${ANA_VER}"
    curl -o /tmp/${ANA_VER}-Linux-x86_64.sh ${REPO}/${URL_PATH}/${ANA_VER}-Linux-x86_64.sh
    bash /tmp/${ANA_VER}-Linux-x86_64.sh -b -p /opt/python/${PY_VER}
    rm /tmp/${ANA_VER}-Linux-x86_64.sh

    echo "Verify Python ${PY_VER}"
    /opt/python/${PY_VER}/bin/python --version

    echo "Install virtualenv Python ${PY_VER}"
    /opt/python/${PY_VER}/bin/pip install -U pip virtualenv==16.1.0
done

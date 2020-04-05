#!/bin/bash

set -xe

export DEBIAN_FRONTEND=noninteractive

export R_VERSION=${R_VERSION:-3.6.3}

mkdir -p /opt/R

apt-get update
apt-get install -y gdebi-core

# R Package Dependencies
apt-get install -y build-essential libcurl4-gnutls-dev openjdk-7-* libxml2-dev libssl-dev texlive-full

for R_VER in ${R_VERSION}
do
    curl -o /tmp/r-${R_VER}_1_amd64.deb https://cdn.rstudio.com/r/ubuntu-1804/pkgs/r-${R_VER}_1_amd64.deb
    gdebi --non-interactive /tmp/r-${R_VER}_1_amd64.deb
    rm /tmp/r-${R_VER}_1_amd64.deb
done

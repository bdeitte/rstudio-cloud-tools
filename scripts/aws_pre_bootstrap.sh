#!/bin/bash
set -ex

export DEBIAN_FRONTEND=noninteractive

sleep 30  # We needs this (?) or apt fails
apt-get clean
apt-get update

# Utility scripts
mv /tmp/wait-for-it.sh /usr/local/bin/wait-for-it.sh
chmod +x /usr/local/bin/wait-for-it.sh

# CloudFormation Helper Scripts
apt-get update
apt-get install -y apt-transport-https python-pip
pip install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz

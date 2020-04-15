#!/bin/bash
set -ex

# rm -rf /tmp/*
rm -rf /root/.ssh/authorized_keys /home/ubuntu/.ssh/authorized_keys

apt-get autoremove -y
apt-get autoclean -y
rm -rf /var/lib/apt/lists/*

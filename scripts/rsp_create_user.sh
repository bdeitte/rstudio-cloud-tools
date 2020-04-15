#!/bin/bash
set -ex


RSP_USERNAME=${RSP_USERNAME:-rstudio-user}
RSP_PASSWORD=${RSP_PASSWORD:-rstudio}

# Create rstudio-team group
groupadd rstudio-team
GROUP_ID=$(cut -d: -f3 < <(getent group rstudio-team))

# Create user
adduser --disabled-password --gecos "" --gid $GROUP_ID $RSP_USERNAME

# Set password
echo "$RSP_USERNAME:$RSP_PASSWORD" | chpasswd

# Add default user to sudoers with no password
echo "$RSP_USERNAME ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

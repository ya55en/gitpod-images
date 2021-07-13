#! /bin/sh
# Setup ubuntu-dev:base image for 'docker build'

# References:
# [1] https://askubuntu.com/questions/1173337/how-to-prevent-system-from-being-minimized
# [2] https://wiki.ubuntu.com/Minimal

## Install mandatory and important packages

export DEBIAN_FRONTEND=noninteractive

# Install prerequisites to `unminimize`
apt-get update
apt-get install -y apt-utils
apt-get install -y locales man-db

# unminimize the minimal image (See [1, 2])
echo "@@@@@ BEGIN unminimize -----------------------------------------"
yes | unminimize
echo "@@@@@ END unminimize -------------------------------------------"

# Create useful/needed config files
echo 'APT::Install-Recommends "false";' > /etc/apt/apt.conf.d/85custom


# Upgrade all and install packages
apt-get -y dist-upgrade
apt-get install -y tzdata locales sudo

PACKAGES='bzip2 unzip unrar wget curl less'
PACKAGES="$PACKAGES git make build-essential"
PACKAGES="$PACKAGES time htop less lsof vim bash-completion"
PACKAGES="$PACKAGES gnupg2 ca-certificates"

apt-get install -y $PACKAGES

# Package installation done
apt-get clean


## Prepare gitpod user environment

GITPOD_HOME=/home/gitpod

# Create Gitpod user as a sudoer
useradd -l -u 33333 -G sudo -md $GITPOD_HOME -s /bin/bash -p gitpod gitpod
# passwordless sudo for users in the 'sudo' group
sed -i.bkp -e 's|%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL|%sudo ALL=NOPASSWD:ALL|g' /etc/sudoers

# Test gitpod user sudo
sudo echo "@@@@@ Running 'sudo' for Gitpod: SUCCESS."

# Create gitpod user local directory
mkdir -p $GITPOD_HOME/.local/{bin,share}

# Create .bashrc.d directory and setup .bashrc to source anything in it
mkdir $GITPOD_HOME/.bashrc.d/

cat >> $GITPOD_HOME/.bashrc <<EOS

# Source anything in ~/.bashrc.d/
for f in \$HOME/.bashrc.d/*; do source \$f; done

EOS
echo "alias hello='echo Hello, \$USER'" > $GITPOD_HOME/.bashrc.d/hello.sh

chown -R gitpod:gitpod $GITPOD_HOME

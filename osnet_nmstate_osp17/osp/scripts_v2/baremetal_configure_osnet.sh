#!/bin/bash
###########################################################
# This script runs on the hypervisor node ################
###########################################################

set -ex

yum install -y git python3 libselinux-python3 patch tmux wget
yes|ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

if [ -d infrared ]; then
    rm -rf infrared
fi
git clone https://github.com/os-net-config/os-net-config.git
cd os-net-config/

if [ -d .venv ]; then
    rm -rf .venv
fi
python3 -m venv .venv
echo "export IR_HOME=`pwd`" >> .venv/bin/activate
source .venv/bin/activate
pip install -U pip
pip install .
#infrared plugin add all

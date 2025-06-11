#!/bin/bash
###########################################################
# This script runs on the hypervisor node ################
###########################################################

set -ex

yum install -y git python3 libselinux-python3 pip patch tmux wget openvswitch3.3
yes|ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

if [ -d os-net-config ]; then
    rm -rf os-net-config
fi
git clone https://github.com/os-net-config/os-net-config.git
cd os-net-config/
python3 setup.py install --prefix=/usr

# os-net-config -p nmstate -c <yaml> -d

if [ -d .venv ]; then
    rm -rf .venv
fi
python3 -m venv .venv
echo "export IR_HOME=`pwd`" >> .venv/bin/activate
source .venv/bin/activate
pip install oslo_concurrency jsonschema tox
pip install -U pip
pip install .

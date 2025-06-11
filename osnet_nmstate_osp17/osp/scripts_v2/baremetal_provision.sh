#!/bin/bash

set -ex

echo "Worskpace dir is $WORKSPACE"
echo "Server is $server"
echo "RHEL Version is $rhel"
echo "Beaker User Credentials ID is $beaker_user"

if [ -z $server ]; then
    echo "Server($server) is invalid"
    exit 1
fi

if [[ $server == "---" ]]; then
    echo "Server($server) is invalid"
    exit 1
fi

if [[ $rhel == "default" || $rhel == "8.2" ]]; then
    echo "Using RHEL 8.2"
    RHEL_VERSION="8.2"
elif [[ $rhel == "8.4" ]]; then
    echo "Using RHEL 8.4"
    RHEL_VERSION="8.4"
elif [[ $rhel == "7.9" ]]; then
    echo "Using RHEL 7.9"
    RHEL_VERSION="7.9"
else
    echo "ERROR: Unsupported RHEL Version (${rhel})!"
    exit 1
fi

git clone https://github.com/redhat-openstack/infrared.git
cd infrared/
python3 -m venv .venv
echo "export IR_HOME=`pwd`" >> .venv/bin/activate
source .venv/bin/activate
pip install -U pip
pip install .
infrared plugin add all

# Create Distro file for rhel-8.2 image
echo 'distro_id: "119464"' > plugins/beaker/vars/image/rhel-8.4.yml
echo 'distro_id: "109050"' > plugins/beaker/vars/image/rhel-8.2.yml
echo 'distro_id: "112769"' > plugins/beaker/vars/image/rhel-7.9.yml

ir beaker --url='https://beaker.engineering.redhat.com' \
    --beaker-user="$beakerusr" --beaker-password="$beakerpass" \
    --host-address="$server" --image="rhel-${RHEL_VERSION}" \
    --host-pubkey "$HOME/.ssh/id_rsa.pub" \
    --host-privkey "$HOME/.ssh/id_rsa" --web-service 'rest' \
    --host-password="$beakerpass"  --host-user='root'  --release='True'

ir beaker --url='https://beaker.engineering.redhat.com' \
    --beaker-user="$beakerusr" --beaker-password="$beakerpass" \
    --host-address="$server" --image="rhel-${RHEL_VERSION}"  \
    --host-pubkey "$HOME/.ssh/id_rsa.pub" \
    --host-privkey "$HOME/.ssh/id_rsa" --web-service 'rest' \
    --host-password="$beakerpass"  --host-user='root'

#!/bin/bash
###########################################################
# This script runs on the hypervisor node ################
###########################################################

set -ex

if [ "$#" -ne 2 ]; then
    echo "ERROR: Invalid Arguments"
    exit 1
fi

RELEASE=$1
BUILD=$2

cd /root/infrared
source .venv/bin/activate

echo "OSP rel. $RELEASE, build: $BUILD"

SSL=""
REPO=""
# Use undercloud SSL only with OSP16 onwards
if [[ ${RELEASE} != "13" ]]; then
    # Facing error after installing shift-on-stack, fix it before enabling it
    SSL="--ssl yes --tls-ca https://password.corp.redhat.com/RH-IT-Root-CA.crt"
REPO="--repos-urls http://download.eng.pek2.redhat.com/rcm-guest/puddles/OpenStack/17.1-RHEL-9/latest-RHOS-17.1-RHEL-9.2/compose/OpenStack/x86_64/os/"
    #REPO="--repos-urls http://download-node-02.eng.bos.redhat.com/rhel-8/nightly/updates/FDP/latest-FDP-8-RHEL-8/compose/Server/x86_64/os/fdp-nightly-updates.repo"
fi

local_ip=$(awk -F "=" '/^local_ip/{print $2}' /root/infrared/undercloud.conf | xargs)
undercloud_public_host=$(awk -F "=" '/^undercloud_public_host/{print $2}' /root/infrared/undercloud.conf | xargs)
undercloud_admin_host=$(awk -F "=" '/^undercloud_admin_host/{print $2}' /root/infrared/undercloud.conf | xargs)
cidr=$(awk -F "=" '/^cidr/{print $2;exit}' /root/infrared/undercloud.conf | xargs)
dhcp_start=$(awk -F "=" '/^dhcp_start/{print $2;exit}' /root/infrared/undercloud.conf | xargs)
dhcp_end=$(awk -F "=" '/^dhcp_end/{print $2;exit}' /root/infrared/undercloud.conf | xargs)
gateway=$(awk -F "=" '/^gateway/{print $2;exit}' /root/infrared/undercloud.conf | xargs)
inspection_iprange=$(awk -F "=" '/^inspection_iprange/{print $2;exit}' /root/infrared/undercloud.conf | xargs)

infrared tripleo-undercloud -vv \
    -o undercloud.yml --mirror "brq2" \
    --version $RELEASE --build ${BUILD} \
    --boot-mode "uefi" \
    --images-task=rpm --images-update no ${SSL} ${REPO} \
    --config-options DEFAULT.local_ip=${local_ip} \
    --config-options DEFAULT.undercloud_public_host=${undercloud_public_host} \
    --config-options DEFAULT.undercloud_admin_host=${undercloud_admin_host} \
    --config-options ctlplane-subnet.cidr=${cidr} \
    --config-options ctlplane-subnet.dhcp_start=${dhcp_start} \
    --config-options ctlplane-subnet.dhcp_end=${dhcp_end} \
    --config-options ctlplane-subnet.gateway=${gateway} \
    --config-options ctlplane-subnet.inspection_iprange=${inspection_iprange} \
    --config-options ctlplane-subnet.masquerade=true \
    --config-options DEFAULT.undercloud_timezone=UTC \
    --tls-ca https://certs.corp.redhat.com/certs/Current-IT-Root-CAs.pem

infrared ssh undercloud-0 "sudo yum install -y wget tmux vim"
infrared ssh undercloud-0 "echo 'set-window-option -g xterm-keys on' >~/.tmux.conf"

# Copy authorized keys of hypervisor to undercloud to allow ssh via proxy
OPT="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
scp $OPT /root/.ssh/authorized_keys stack@undercloud-0:~/hypervisor.authorized_keys
infrared ssh undercloud-0 "cat ~/hypervisor.authorized_keys >>~/.ssh/authorized_keys"

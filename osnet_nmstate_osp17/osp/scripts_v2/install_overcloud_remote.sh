#!/bin/bash

PARAMS="$*"
USER_THT="$HOME/osp17_ref"

#mkdir -p mount_image
#guestmount -a overcloud-hardened-uefi-full.raw -i --rw mount_image
#cd ..
#guestunmount mount_image
#exit

#virt-customize -a overcloud-hardened-uefi-full.qcow2 --upload nmstate/impl_nmstate.py:/usr/lib/python3.9/site-packages/os_net_config/impl_nmstate.py
#vi nmstate/cli.py
#virt-customize -a overcloud-hardened-uefi-full.qcow2 --upload nmstate/cli.py:/usr/lib/python3.9/site-packages/os_net_config/cli.py
#vi nmstate/objects.py
#virt-customize -a overcloud-hardened-uefi-full.qcow2 --upload nmstate/objects.py:/usr/lib/python3.9/site-packages/os_net_config/objects.py


echo "Pre-provision node...."

infrared tripleo-overcloud -vv --version 
    --version $RELEASE \
    --introspect=no --tagging=no \
    --tht-roles yes --deploy=yes \
    --overcloud-templates none --network-ovn yes \
    --network-ovs no --network-backend geneve \
    --network-protocol ipv4 --overcloud-ssl yes \
    --deployment-files osp-dev-lab-tht/osp17_ref \
    -e provison_virsh_network_name=ctlplane-subnet \
    --hybrid instack.json \
    --overcloud-script /root/infrared/overcloud_deploy.sh

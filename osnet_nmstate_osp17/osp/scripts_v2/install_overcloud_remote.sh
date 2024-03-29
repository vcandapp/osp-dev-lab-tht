#!/bin/bash

set -ex

PARAMS="$*"
RELEASE=$1

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

#yes|ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""
#cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

echo "Pre-provision node...."
echo "Deploying OSP version ${RELEASE}"

cd /root/infrared/
source .venv/bin/activate

if [ ! -d osnet_nm_dev_auto_tht ]; then
    git clone https://github.com/vcandapp/osnet_nm_dev_auto_tht.git
fi

infrared tripleo-overcloud -o overcloud-install.yml --version ${RELEASE} --deployment-files osnet_nm_dev_auto_tht/osp17_ref  --overcloud-templates none --storage-backend lvm --overcloud-ssl no --network-backend vxlan --network-protocol ipv4 --network-bgpvpn no  --network-dvr no  --network-l2gw no --storage-external no --splitstack no --overcloud-debug yes --overcloud-fencing no  --introspect no  --tagging no --tht-roles yes --deploy yes  --containers True --hybrid instack.json -e provison_virsh_network_name=br-ctlplane  --overcloud-script /root/infrared/overcloud_deploy.sh --collect-ansible-facts False --ntp-pool clock.corp.redhat.com,clock1.rdu2.redhat.com,google.com

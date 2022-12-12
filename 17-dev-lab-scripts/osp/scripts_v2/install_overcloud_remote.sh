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
THT_PATH=$2

#repo_url='http://github.com/rh-nfv-int/osp-dev-lab-tht.git'
#THT_URL="${repo_url}"
#TMPL_DIR="osp${release%.*}_ref"

#THT_BASE=`basename $THT_URL`
#THT_DIR="${THT_BASE%.git}"

cd /root/infrared
source .venv/bin/activate

UNDER_SUBNET=$(cat undercloud.conf |grep ^local_subnet|awk 'BEGIN{FS=OFS="="} {print $2}'|sed 's/ //'g)
if [ -z $UNDER_SUBNET ]; then
  UNDER_SUBNET=br-ctlplane
fi

if [[ ${RELEASE} == "13" ]]; then
    NET_BACKEND=' --network-ovn no --network-ovs yes --network-backend vxlan '
else
    NET_BACKEND=' --network-ovn yes --network-ovs no --network-backend geneve '
fi

CONTAINER= --containers True

infrared tripleo-overcloud -o overcloud-install.yml --version ${RELEASE} --deployment-files 17-dev-lab-scripts/osp17_ref  --overcloud-templates none --overcloud-ssl no ${NET_BACKEND} --network-protocol ipv4 --network-bgpvpn no  --network-dvr no  --network-l2gw no --storage-external no --splitstack no --overcloud-debug yes --overcloud-fencing no  --introspect no  --tagging no --tht-roles yes --deploy yes  --containers True --hybrid instack.json -e provison_virsh_network_name=br-ctlplane  --overcloud-script /root/infrared/overcloud_deploy.sh --collect-ansible-facts False --ntp-pool clock.corp.redhat.com,clock1.rdu2.redhat.com,google.com


#-e provison_virsh_network_name=${UNDER_SUBNET} \
#infrared tripleo-overcloud -o overcloud-install.yml
#--vbmc-force False --vbmc-host undercloud --tagging no --deploy no --boot-mode "bios"

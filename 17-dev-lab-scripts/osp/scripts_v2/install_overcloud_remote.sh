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

infrared tripleo-overcloud -vv \
    --version ${RELEASE} \
    --introspect=no --tagging=no --tht-roles yes --deploy=yes --overcloud-templates none \
    ${NET_BACKEND} --network-protocol ipv4 \
    --overcloud-ssl yes \
    -e provison_virsh_network_name=br-ctlplane \
    --deployment-files ${THT_PATH} \
    --hybrid instack.json  --overcloud-script  /root/infrared/overcloud_deploy.sh


#-e provison_virsh_network_name=${UNDER_SUBNET} \
#infrared tripleo-overcloud -o overcloud-install.yml
#--vbmc-force False --vbmc-host undercloud --tagging no --deploy no --boot-mode "bios"

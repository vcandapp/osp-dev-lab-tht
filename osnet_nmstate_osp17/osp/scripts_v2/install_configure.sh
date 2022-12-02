#!/bin/bash

set -ex

THT_URL="${repo_url}"
#Viji Fix 17.x for now
TMPL_DIR="osp17_ref"
CMD_FILE="overcloud_deploy_${deploy_type}.sh"
COMMON_NET_DATA="osnet_nmstate_osp17/osp/network_data_v2/${server}"
COMMON_NET_DATA_V2="osnet_nmstate_osp17/osp/network_data_v2/${server}_v2"
COMMON_VIP_CFG="osnet_nmstate_osp17/osp/network_data_v2/vip_data.yaml"
COMMON_BAREMETAL_CFG="osnet_nmstate_osp17/osp/network_data_v2/baremetal_deployment.yaml"

THT_BASE=`basename $THT_URL`
THT_DIR="${THT_BASE%.git}"
THT_PATH="${THT_DIR}/${TMPL_DIR}"

if [ -d $THT_DIR]; then
    rm -rf $THT_DIR
fi
# Cloning to jenkins workspace folder
git clone --depth=1 $THT_URL

OPT="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

if [ ! -f "${THT_PATH}/${CMD_FILE}" ]; then
    echo "ERROR: Deploy file ${THT_PATH}/${CMD_FILE} is not available"
    exit 1
fi
cp ${THT_PATH}/${CMD_FILE} overcloud_deploy.sh
scp ${OPT} overcloud_deploy.sh root@${server}:/root/infrared/

ssh ${OPT} root@${server} "cd infrared/;rm -rf ${THT_DIR}; git clone $THT_URL"

cp $COMMON_NET_DATA ${THT_PATH}/network_data.yaml
awk -v var="$VLAN_CONFIG" 'BEGIN{x=var+1;FS="\\n"}/vlan:/{gsub(/vlan:.*/,"vlan: "x++)} {print}' ${THT_PATH}/network_data.yaml > network_data.yaml
scp ${OPT} network_data.yaml root@${server}:/root/infrared/
scp ${OPT} network_data.yaml root@${server}:/root/infrared/${THT_PATH}/
cp $COMMON_NET_DATA_V2 ${THT_PATH}/network_data_v2.yaml
scp ${OPT} ${THT_PATH}/network_data_v2.yaml root@${server}:/root/infrared/${THT_PATH}/network/
scp ${OPT} $COMMON_VIP_CFG root@${server}:/root/infrared/${THT_PATH}/network/
scp ${OPT} $COMMON_BAREMETAL_CFG root@${server}:/root/infrared/${THT_PATH}/network/

awk -v var="$VLAN_CONFIG" 'BEGIN{x=var;FS="\\n"} /NeutronNetworkVLANRanges:/{gsub("NeutronNetworkVLANRanges:.*","NeutronNetworkVLANRanges: dpdk1:"x+5":"x+10",dpdk2:"x+5":"x+10",sriov1:"x+5":"x+10",sriov2:"x+5":"x+10   )} {print}' ${THT_PATH}/network-environment.yaml > network-environment.yaml
scp ${OPT} network-environment.yaml root@${server}:/root/infrared/${THT_PATH}

cp ${THT_PATH}/undercloud_hybrid.conf undercloud.conf
scp $OPT undercloud.conf root@${server}:/root/infrared/

if [ -z $ipmipass ]; then
    echo "ERROR: IPMI password it not provided"
    exit 1
fi
export ipmi_password=$ipmipass
envsubst < osnet_nmstate_osp17/osp/instackenv/${server} >instack.json
cat instack.json
scp $OPT instack.json root@${server}:/root/infrared/

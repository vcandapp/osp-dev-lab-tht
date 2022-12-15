#!/bin/bash
###########################################################
# This script runs on the hypervisor node ################
###########################################################

set -ex

if [ "$#" -ne 3 ]; then
    echo "ERROR: Invalid Arguments"
    exit 1
fi

RELEASE=$1
THT_PATH=$2
SERVER=$3

if [[ $SERVER == "dell-r640-oss-01.lab.eng.brq2.redhat.com" ]]; then
    BOOT_MODE='"bios"'
else
    BOOT_MODE='"uefi"'
fi
echo "Setting boot mode ($BOOT_MODE) for ($SERVER)"

echo "Deploying OSP version ${REALEASE}"

cd /root/infrared/
source .venv/bin/activate

infrared tripleo-overcloud -vv -o prepare_instack.yml --version ${RELEASE} --introspect=yes --tagging=yes --deploy=no --deployment-files ${THT_PATH} -e provison_virsh_network_name=br-ctlplane --hybrid instack.json --vbmc-host hypervisor  --boot-mode ${BOOT_MODE}

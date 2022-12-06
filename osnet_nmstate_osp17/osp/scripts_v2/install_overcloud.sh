#!/bin/bash

set -ex

git_base="osnet_nm_dev_auto_tht"
repo_url='https://github.com/vcandapp/osnet_nm_dev_auto_tht.git'
THT_URL="${repo_url}"
TMPL_DIR="osp${release%.*}_ref"

THT_BASE=`basename $THT_URL`
THT_DIR="${THT_BASE%.git}"
THT_PATH="${THT_DIR}/${TMPL_DIR}"

if [ -d "${THT_DIR}" ]; then
    rm -rf /root/infrared/${THT_DIR}
fi

# Cloning to jenkins workspace folder
git clone --depth=1 $THT_URL

OPT="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

scp $OPT overcloud_deploy.sh  root@${server}:/root/infrared/

scp $OPT osnet_nmstate_osp17/osp/scripts_v2/install_overcloud_remote.sh root@${server}:/root/
CMD="bash /root/install_overcloud_remote.sh ${release} ${THT_PATH}"
ssh $OPT root@${server} "echo ${CMD}>>/root/auto-cmd-history"
ssh $OPT root@${server} ${CMD}

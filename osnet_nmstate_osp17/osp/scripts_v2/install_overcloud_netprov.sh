#!/bin/bash

set -ex

THT_URL="${repo_url}"
TMPL_DIR="osp${release%.*}_ref"

THT_BASE=`basename $THT_URL`
THT_DIR="${THT_BASE%.git}"
THT_PATH="${THT_DIR}/${TMPL_DIR}"

OPT="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

scp $OPT osnet_nmstate_osp17/osp/scripts_v2/install_overcloud_netprov_remote.sh root@${server}:/root/
CMD="bash /root/install_overcloud_netprov_remote.sh ${release} ${THT_PATH}"
ssh $OPT root@${server} "echo ${CMD}>>/root/auto-cmd-history"
ssh $OPT root@${server} ${CMD}

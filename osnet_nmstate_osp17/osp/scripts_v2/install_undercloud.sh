#!/bin/bash

set -ex

OPT="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

scp $OPT osnet_nmstate_osp17/osp/scripts_v2/install_undercloud_remote.sh root@${server}:/root/
CMD="bash /root/install_undercloud_remote.sh ${release} ${build}"
ssh $OPT root@${server} "echo ${CMD}>>/root/auto-cmd-history"
ssh $OPT root@${server} ${CMD}

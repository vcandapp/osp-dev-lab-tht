#!/bin/bash

set -ex

OPT="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

scp $OPT osnet_nmstate_osp17/osp/scripts_v2/baremetal_configure_remote.sh root@${server}:/root/
CMD="bash /root/baremetal_configure_remote.sh"
ssh $OPT root@${server} "echo ${CMD}>>/root/auto-cmd-history"
ssh $OPT root@${server} ${CMD}

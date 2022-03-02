#!/bin/bash

set -ex

OPT="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

scp $OPT 17-dev-lab-scripts/osp/scripts_v2/install_undercloud_remote.sh root@${server}:/root/
CMD="bash /root/install_undercloud_remote.sh ${release} ${build}"
ssh $OPT root@${server} "echo ${CMD}>>/root/auto-cmd-history"
ssh $OPT root@${server} ${CMD}

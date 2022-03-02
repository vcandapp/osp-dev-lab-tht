#!/bin/bash

set -ex

OPT="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

scp $OPT osp/scripts_v2/install_clean_remote.sh root@${server}:/root/
CMD="bash /root/install_clean_remote.sh ${server}"
ssh $OPT root@${server} "echo ${CMD}>>/root/auto-cmd-history"
ssh $OPT root@${server} ${CMD}

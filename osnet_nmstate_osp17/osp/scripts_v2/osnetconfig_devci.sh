#!/bin/bash

set -ex

OPT="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

scp $OPT osnet_nmstate_osp17/osp/scripts_v2/osnetconfig_devci_remote root@${server}:/root/
CMD="bash /root/osnetconfig_devci_remote"
ssh $OPT root@${server} "echo ${CMD}>>/root/auto-cmd-history"
ssh $OPT root@${server} ${CMD}

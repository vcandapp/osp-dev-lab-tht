#!/bin/bash

PARAMS="$*"
USER_THT="$HOME/osp17_ref"

echo "Network provision node...."

if [ ! -d /home/stack/templates ]; then
    mkdir -p /home/stack/templates
fi

openstack overcloud network provision \
  -y --stack overcloud \
  --output $HOME/templates/overcloud-networks-deployed.yaml \
  /home/stack/osp17_ref/network/network_data_v2.yaml

openstack overcloud network vip provision \
  --stack overcloud -y \
  --templates /usr/share/openstack-tripleo-heat-templates  \
  -o $HOME/templates/overcloud-vip-deployed.yaml  \
  /home/stack/osp17_ref/network/vip_data.yaml

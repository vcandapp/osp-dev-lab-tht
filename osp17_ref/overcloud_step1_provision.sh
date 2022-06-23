#!/bin/bash

PARAMS="$*"
USER_THT="$HOME/osp17_ref"

echo "Pre-provision node...."
openstack overcloud roles generate -o $HOME/roles_data.yaml ControllerSriov ComputeOvsDpdkSriov

openstack overcloud node provision \
  --stack overcloud \
  --timeout 120  \
  --network-config \
  --templates /usr/share/openstack-tripleo-heat-templates \
  --working-dir /home/stack/overcloud_deploy_17 \
  --output ~/overcloud-baremetal-deployed.yaml \
  /home/stack/osp17_ref/network/baremetal_deployment.yaml

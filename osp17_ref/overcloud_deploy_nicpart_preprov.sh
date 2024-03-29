#!/bin/bash

PARAMS="$*"
USER_THT="$HOME/osp17_ref"

# Always generate roles_data file
openstack overcloud roles generate -o $HOME/roles_data.yaml Controller ComputeSriov ComputeOvsDpdkSriov

openstack overcloud deploy $PARAMS \
    --templates \
    --ntp-server clock1.rdu2.redhat.com \
    --stack overcloud \
    -r /home/stack/roles_data.yaml \
    -n $USER_THT/network/network_data_v2.yaml \
    --deployed-server \
    -e /home/stack/templates/overcloud-baremetal-deployed.yaml \
    -e /home/stack/templates/overcloud-networks-deployed.yaml \
    -e /home/stack/templates/vip-deployed-environment.yaml \
    -e
/usr/share/openstack-tripleo-heat-templates/environments/deployed-server-environment.yaml \
    -e /usr/share/openstack-tripleo-heat-templates/environments/disable-telemetry.yaml \
    -e /usr/share/openstack-tripleo-heat-templates/environments/debug.yaml \
    -e /usr/share/openstack-tripleo-heat-templates/environments/config-debug.yaml \
    -e /usr/share/openstack-tripleo-heat-templates/environments/services/neutron-ovs.yaml \
    -e /usr/share/openstack-tripleo-heat-templates/environments/services/neutron-ovs-dpdk.yaml \
    -e /usr/share/openstack-tripleo-heat-templates/environments/services/neutron-sriov.yaml \
    -e $USER_THT/network-environment.yaml \
    -e $USER_THT/network-environment-nicpart.yaml \
    -e $USER_THT/ml2-ovs-nfv.yaml \
    -e $HOME/containers-prepare-parameter.yaml \
    --log-file overcloud_deployment.log

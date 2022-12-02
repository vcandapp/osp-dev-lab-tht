#!/bin/bash

PARAMS="$*"
USER_THT="$HOME/osp17_ref"

if [ ! -d /home/stack/images ]; then
    mkdir -p /home/stack/images
    pushd /home/stack/images
    for i in /usr/share/rhosp-director-images/overcloud-hardened-uefi-full.tar  /usr/share/rhosp-director-images/ironic-python-agent-latest.tar; do tar -xvf $i; done
    sudo yum install libguestfs-tools -y
    export LIBGUESTFS_BACKEND=direct
    virt-customize --root-password password:redhat -a overcloud-hardened-uefi-full.qcow2
    openstack overcloud image upload --os-image-name overcloud-hardened-uefi-full.qcow2 --update-existing
    for i in $(openstack baremetal node list -c UUID -f value); do openstack overcloud node configure --boot-mode "uefi" $i; done
    popd
fi

#mkdir -p mount_image
#guestmount -a overcloud-hardened-uefi-full.raw -i --rw mount_image
#cd ..
#guestunmount mount_image
#exit

#virt-customize -a overcloud-hardened-uefi-full.qcow2 --upload nmstate/impl_nmstate.py:/usr/lib/python3.9/site-packages/os_net_config/impl_nmstate.py
#vi nmstate/cli.py
#virt-customize -a overcloud-hardened-uefi-full.qcow2 --upload nmstate/cli.py:/usr/lib/python3.9/site-packages/os_net_config/cli.py
#vi nmstate/objects.py
#virt-customize -a overcloud-hardened-uefi-full.qcow2 --upload nmstate/objects.py:/usr/lib/python3.9/site-packages/os_net_config/objects.py


echo "Pre-provision node...."

openstack overcloud node provision \
  --stack overcloud \
  --timeout 120  \
  --network-config -y \
  --templates /usr/share/openstack-tripleo-heat-templates \
  --working-dir /home/stack/overcloud_deploy_17 \
  --output $HOME/templates/overcloud-baremetal-deployed.yaml \
  $USER_THT/network/baremetal_deployment_nm.yaml

#!/bin/bash
set -ex
case "$PACKER_BUILDER_TYPE" in
  virtualbox-*)
    apt-get install -y build-essential "pve-headers-$(uname -r)"
    mount -o loop VBoxGuestAdditions.iso /mnt
    /mnt/VBoxLinuxAdditions.run || :
    umount /mnt
    rm -f VBoxGuestAdditions.iso
    ;;
  vmware-*)
    apt-get install -y open-vm-tools
    ;;
esac
